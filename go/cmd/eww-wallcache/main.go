package main

import (
	"encoding/base64"
	"encoding/binary"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/cespare/xxhash"
	"github.com/spf13/pflag"
)

type Index struct {
	kv map[string]string
	vk map[string]string
}

var (
	_ json.Marshaler   = (*Index)(nil)
	_ json.Unmarshaler = (*Index)(nil)
)

func NewIndex() *Index {
	return &Index{kv: make(map[string]string), vk: make(map[string]string)}
}

func (i Index) MarshalJSON() ([]byte, error) {
	return json.Marshal(i.kv)
}

func (i *Index) UnmarshalJSON(data []byte) error {
	kv := make(map[string]string)
	err := json.Unmarshal(data, &kv)
	if err != nil {
		return err
	}
	i.kv = kv
	for key, value := range kv {
		i.vk[value] = key
	}
	return nil
}

func (i *Index) Delete(key string) {
	value, ok := i.kv[key]
	if !ok {
		return
	}
	delete(i.kv, key)
	delete(i.vk, value)
}

func (i *Index) KeyValue() map[string]string {
	return i.kv
}

func (i *Index) Set(path, hash string) {
	i.kv[path] = hash
	i.vk[hash] = path
}

func (i *Index) GetHash(path string) (string, bool) {
	v, ok := i.kv[path]
	return v, ok
}

func (i *Index) GetPath(hash string) (string, bool) {
	v, ok := i.vk[hash]
	return v, ok
}

func getWallpaperDir() string {
	home, _ := os.UserHomeDir()
	return filepath.Join(home, "Pictures", "Wallpapers")
}

func getCacheDir() string {
	cache := os.Getenv("XDG_CACHE_HOME")
	if cache == "" {
		home, _ := os.UserHomeDir()
		cache = filepath.Join(home, ".cache")
	}
	return filepath.Join(cache, "eww-wallcache")
}

func hash(path string) (string, error) {
	file, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer file.Close()

	hasher := xxhash.New()
	if _, err := io.Copy(hasher, file); err != nil {
		return "", err
	}

	sum := hasher.Sum64()
	buf := make([]byte, 8)
	binary.BigEndian.PutUint64(buf, sum)
	return base64.RawURLEncoding.EncodeToString(buf), nil
}

func loadIndex(cacheDir string) (*Index, error) {
	indexPath := filepath.Join(cacheDir, "index.json")
	file, err := os.Open(indexPath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	i := NewIndex()
	if err := json.NewDecoder(file).Decode(&i); err != nil {
		return i, err
	}
	return i, nil
}

func saveIndex(cacheDir string, index *Index) error {
	data, err := json.MarshalIndent(index, "", "  ")
	if err != nil {
		return err
	}

	indexPath := filepath.Join(cacheDir, "index.json")
	return os.WriteFile(indexPath, data, 0644)
}

func findImages(dir string) ([]string, error) {
	exts := map[string]bool{
		".png":  true,
		".jpg":  true,
		".jpeg": true,
		".webp": true,
	}

	var files []string
	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return nil
		}
		if exts[strings.ToLower(filepath.Ext(path))] {
			files = append(files, path)
		}
		return nil
	})
	return files, err
}

func checkBinary(bin string) bool {
	_, err := exec.LookPath(bin)
	return err == nil
}

func runCache(cacheDir string) {
	wallpaperDir := getWallpaperDir()
	os.MkdirAll(cacheDir, 0755)

	// Load or initialize index
	index, err := loadIndex(cacheDir)
	if err != nil {
		index = NewIndex()
	}

	// Find all images
	files, err := findImages(wallpaperDir)
	if err != nil {
		slog.Error("Error finding images", "error", err)
		return
	}

	// Process files
	for _, file := range files {
		if h, ok := index.GetHash(file); ok {
			cacheFile := filepath.Join(cacheDir, h+".jpg")
			_, err := os.Stat(cacheFile)
			if err == nil {
				continue
			}
		}

		h, err := hash(file)
		if err != nil {
			slog.Error("Error hashing file", "file", file, "error", err)
			continue
		}

		cacheFile := filepath.Join(cacheDir, h+".jpg")
		if _, err := os.Stat(cacheFile); err == nil {
			index.Set(file, h)
			continue
		}

		// Create cache
		slog.Info("Cache", "path", file, "cache", cacheFile)
		cmd := exec.Command("magick", file, "-resize", "300x", "-strip", "-quality", "80", cacheFile)
		if err := cmd.Run(); err != nil {
			slog.Error("Error creating cache", "file", file, "error", err)
			continue
		}
		index.Set(file, h)
	}

	for path, hash := range index.KeyValue() {
		if _, err := os.Stat(path); errors.Is(os.ErrNotExist, err) {
			cacheFile := filepath.Join(cacheDir, hash+".jpg")
			slog.Info("Deleting orphan cache", "path", cacheFile)
			os.Remove(cacheFile)
			index.Delete(path)
		}
	}

	// Save index
	if err := saveIndex(cacheDir, index); err != nil {
		slog.Error("Error saving index", "error", err)
	}
}

type Colors struct {
	Material struct {
		Primary struct {
			HexRGB string `json:"hex_rgb"`
		} `json:"primary"`
		Secondary struct {
			HexRGB string `json:"hex_rgb"`
		} `json:"secondary"`
		Tertiary struct {
			HexRGB string `json:"hex_rgb"`
		} `json:"tertiary"`
	} `json:"material"`
}

func generateColors(path string) (c Colors, err error) {
	cmd := exec.Command("rong", "image", "--dry-run", "--json", "--quiet", path)
	output, err := cmd.Output()
	if err != nil {
		slog.Error("Error running rong", "target", path, "error", err)
		return
	}

	if err = json.Unmarshal(output, &c); err != nil {
		slog.Error("Error parsing rong output", "error", err)
		return
	}
	return c, nil
}

func runList(cacheDir string) {
	runCache(cacheDir)
	index, err := loadIndex(cacheDir)
	if err != nil {
		slog.Error("Error loading index", "error", err)
		return
	}

	wallpaperDir := getWallpaperDir()
	os.MkdirAll(cacheDir, 0755)

	// Find all images
	files, err := findImages(wallpaperDir)
	if err != nil {
		slog.Error("Error finding images", "error", err)
		return
	}

	type result struct {
		Path      string `json:"path"`
		Primary   string `json:"primary"`
		Secondary string `json:"secondary"`
		Tertiary  string `json:"tertiary"`
	}

	var results []result

	for _, file := range files {
		data, err := generateColors(file)
		if err != nil {
			continue
		}

		target := file
		if h, ok := index.GetHash(file); ok {
			cacheFile := filepath.Join(cacheDir, h+".jpg")
			_, err := os.Stat(cacheFile)
			if err == nil {
				target = cacheFile
			}
		}
		if target == file {
			slog.Error("Cache doesn't exists", "path", file)
		}

		results = append(results, result{
			Path:      target,
			Primary:   data.Material.Primary.HexRGB,
			Secondary: data.Material.Secondary.HexRGB,
			Tertiary:  data.Material.Tertiary.HexRGB,
		})

	}

	err = json.NewEncoder(os.Stdout).Encode(results)
	if err != nil {
		slog.Error("Error marshaling results", "error", err)
		return
	}
}

func runResolve(cacheDir, path string) {
	index, err := loadIndex(cacheDir)
	if err != nil {
		slog.Error("Error loading index", "error", err)
		return
	}

	hash := strings.TrimSuffix(filepath.Base(path), ".jpg")
	if original, ok := index.GetPath(hash); ok {
		fmt.Println(original)
		return
	}
	slog.Error("Unable to resoble original path")
}

func main() {
	pflag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [cache|list|resolve]\n", os.Args[0])
		pflag.PrintDefaults()
	}
	pflag.Parse()

	cacheDir := getCacheDir()
	os.MkdirAll(cacheDir, 0755)

	switch cmd := pflag.Arg(0); cmd {
	case "cache":
		if !checkBinary("magick") {
			slog.Error("Required binary not found: magick")
			os.Exit(1)
		}
		runCache(cacheDir)
	case "list":
		if !checkBinary("rong") {
			slog.Error("Required binary not found: rong")
			os.Exit(1)
		}
		runList(cacheDir)
	case "resolve":
		path := pflag.Arg(1)
		if path == "" {
			slog.Error("resolve requires a path argument")
			os.Exit(1)
		}
		runResolve(cacheDir, path)
	default:
		pflag.Usage()
		os.Exit(1)
	}
}
