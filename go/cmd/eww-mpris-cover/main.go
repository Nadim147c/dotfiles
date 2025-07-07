package main

import (
	"crypto/md5"
	"dotfiles/pkg/log"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"strings"
	"time"

	"github.com/Nadim147c/go-mpris"
	"github.com/gabriel-vasile/mimetype"
	"github.com/godbus/dbus/v5"
	"github.com/spf13/pflag"
)

const Extension = ".png"

var CacheDir string

func init() {
	quite := pflag.BoolP("quite", "q", false, "Subpress all logs")

	pflag.Parse()

	if *quite {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelInfo)
	}
}

func main() {
	cache, err := os.UserCacheDir()
	if err != nil {
		panic(err)
	}

	CacheDir = filepath.Join(cache, "mpris-cover")

	if err := os.MkdirAll(cache, 0755); err != nil {
		panic(err)
	}

	conn, err := dbus.SessionBus()
	if err != nil {
		slog.Error("Failed to create dbus connection", "error", err)
		return
	}

	ticker := time.NewTicker(500 * time.Millisecond)
	defer ticker.Stop()

	pathCh := make(chan string)

	go func() {
		var lastCover string
		for path := range pathCh {
			if lastCover != path {
				fmt.Println(path)
				lastCover = path
			}
		}
	}()

	for {
		<-ticker.C
		player, err := SelectPlayer(conn)
		if err != nil {
			slog.Error("Failed to find player", "error", err)
			continue
		}

		meta, err := player.GetMetadata()
		if err != nil {
			slog.Error("Failed to get player metadata", "error", err)
			continue
		}

		coverObj, ok := meta["mpris:artUrl"]
		if !ok {
			slog.Error("Player cover art doesn't exists")
			continue
		}

		cover, ok := coverObj.Value().(string)
		if !ok {
			slog.Error("Failed to parse cover")
			continue
		}

		path, err := GetLocalPath(cover, pathCh)
		if err != nil {
			slog.Error("Failed to get cache cover image", "error", err)
		} else {
			pathCh <- path
		}

	}
}

var supportedPlayers = []string{"spotify", "YoutubeMusic", "amarok", "io.bassi.Amberol"}

// SelectPlayer selects correct parses for player
func SelectPlayer(conn *dbus.Conn) (*mpris.Player, error) {
	players, err := mpris.List(conn)
	if err != nil {
		return nil, err
	}

	if len(players) == 0 {
		return nil, errors.New("No player exists")
	}

	for name := range slices.Values(supportedPlayers) {
		for player := range slices.Values(players) {
			if mpris.BaseInterface+"."+name == player {
				return mpris.New(conn, player), nil
			}
		}
	}

	return nil, errors.New("No player exists")
}

var PathCache = map[string]string{}

func GetLocalPath(url string, pathCh chan string) (string, error) {
	if path, ok := PathCache[url]; ok {
		return path, nil
	}

	// Create URL md5sum
	md5sum := md5.Sum([]byte(url))
	hash := base64.RawURLEncoding.EncodeToString(md5sum[:])
	cachedFile := filepath.Join(CacheDir, hash+Extension)

	if _, err := os.Stat(cachedFile); err == nil {
		return cachedFile, nil
	}

	// Download to temp file
	tmpFile, err := os.CreateTemp("", "imgcache-*.tmp")
	if err != nil {
		return "", err
	}
	tmpPath := tmpFile.Name()
	defer os.Remove(tmpPath)
	defer tmpFile.Close()

	if err := Download(url, tmpFile); err != nil {
		return "", err
	}

	tmpFile.Close()

	// Detect MIME type
	mtype, err := mimetype.DetectFile(tmpPath)
	if err != nil {
		return "", err
	}

	if !strings.HasPrefix(mtype.String(), "image/") {
		return "", errors.New("url is not a image")
	}

	// Handle conversion or move
	if mtype.String() == "image/png" {
		if err := Move(tmpPath, cachedFile); err != nil {
			return "", err
		}
		PathCache[url] = cachedFile
		return cachedFile, nil
	}

	err = Convert(tmpPath, mtype.Extension(), cachedFile, pathCh)
	if err != nil {
		return "", err
	}

	PathCache[url] = cachedFile
	return cachedFile, nil
}

func Move(src, dst string) error {
	srcFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	dstFile, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer dstFile.Close()

	_, err = io.Copy(dstFile, srcFile)
	if err != nil {
		return err
	}

	err = srcFile.Close()
	if err != nil {
		return err
	}

	return os.Remove(src)
}

func Download(url string, out *os.File) error {
	slog.Info("Downloading cover art", "url", url)
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("HTTP status %s", resp.Status)
	}

	_, err = io.Copy(out, resp.Body)
	return err
}

func Convert(input, ext, output string, pathCh chan string) error {
	newName := input + ext

	err := os.Rename(input, newName)
	if err != nil {
		return err
	}
	defer os.Remove(newName)

	pathCh <- newName

	slog.Info("Converting image", "input", newName, "output", output)
	cmd := exec.Command(
		"magick", newName,
		"(", "+clone", "-alpha", "extract",
		"-draw", "fill black polygon 0,0 0,30 30,0 fill white circle 30,30 30,0",
		"(", "+clone", "-flip", ")", "-compose", "Multiply", "-composite",
		"(", "+clone", "-flop", ")", "-compose", "Multiply", "-composite", ")",
		"-alpha", "off", "-compose", "CopyOpacity", "-composite",
		"-resize", "200x",
		output,
	)

	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("imagemagick conversion failed: %w", err)
	}
	return nil
}
