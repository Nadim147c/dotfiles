package main

import (
	"bytes"
	"context"
	"encoding/base64"
	"fmt"
	"image/png"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"slices"
	"strings"
	"syscall"

	"github.com/sahilm/fuzzy"
	"golang.org/x/image/webp"
)

const limit = 30

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer cancel()

	cmd := exec.CommandContext(ctx, "cliphist", "list")

	out, err := cmd.Output()
	if err != nil {
		log.Fatalf("failed to run cliphist: %v", err)
	}

	// cliphist just adds random null bytes
	cleaned := bytes.ReplaceAll(out, []byte{0}, nil)

	byteLines := bytes.Split(cleaned, []byte{'\n'})
	lines := make([]string, len(byteLines))
	for i, byteLine := range byteLines {
		lines[i] = string(byteLine)
	}

	var selected []string
	if len(os.Args) > 1 {
		matches := head(fuzzy.Find(os.Args[1], lines), limit)
		for match := range slices.Values(matches) {
			selected = append(selected, match.Str)
		}
	} else {
		selected = head(lines, limit)
	}

	for line := range slices.Values(selected) {
		clip, err := parseLine(line)
		if err != nil {
			continue
		}
		if clip.kind == "text" {
			fmt.Printf("%s-text:%s\n", clip.id, clip.desc)
			continue
		}
		if len(clip.blob) != 0 {
			based := base64.RawStdEncoding.EncodeToString(clip.blob)
			fmt.Printf("%s-%s:%s\n", clip.id, clip.kind, based)
			continue
		}
		fmt.Printf("%s-%s:\n", clip.id, clip.kind)
	}
}

func head[T any](s []T, n int) []T {
	return s[:min(len(s)-1, n)]
}

type Clip struct {
	id   string // we don't need to parse it to int
	kind string
	desc string
	blob []byte
}

func parseLine(line string) (*Clip, error) {
	id, desc, ok := strings.Cut(line, "\t")
	if !ok {
		return nil, fmt.Errorf("failed to splti id and description")
	}
	clip := new(Clip)
	clip.id = id
	clip.desc = desc
	clip.kind = "text"
	if desc == "" {
		return clip, nil
	}

	if !strings.HasPrefix(desc, "[[ binary data ") || !strings.HasSuffix(desc, "]]") {
		return clip, nil
	}

	fields := strings.Fields(desc)
	if len(fields) < 6 {
		clip.kind = "binary"
		return clip, nil
	}

	kind := fields[5]

	switch kind {
	case "png", "jpg", "jpeg":
		clip.kind = kind
		clip.blob = decode(id)
	case "webp":
		clip.kind = kind
		webpBlob := decode(id)
		img, err := webp.Decode(bytes.NewBuffer(webpBlob))
		if err != nil {
			return clip, err
		}
		buf := bytes.NewBuffer(nil)
		png.Encode(buf, img)
		clip.blob = buf.Bytes()
	default:
		clip.kind = "binary"
	}

	return clip, nil
}

func decode(id string) []byte {
	b, _ := exec.Command("cliphist", "decode", id).Output()
	return b
}
