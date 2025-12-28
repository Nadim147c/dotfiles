package main

import (
	"fmt"
	"hash/fnv"
	"math/rand"
	"os"
	"path/filepath"
	"slices"
	"strings"

	"github.com/Nadim147c/material/v2/color"
	"github.com/Nadim147c/material/v2/num"
	"github.com/spf13/pflag"
)

var (
	flagTone   float64 = 75
	flagChroma float64 = 75
	flagSeed   float64 = 100
	flagDepth  int     = 5
)

func should[T any](v T, err error) T {
	if err != nil {
		panic(err)
	}
	return v
}

func absOr(v, fallback string) string {
	if v == "" {
		return fallback
	}
	return should(filepath.Abs(v))
}

func findGitRepos(root, current string, depth int) []string {
	if depth < 0 {
		return nil
	}

	root = should(filepath.Abs(root))
	current = absOr(current, root)

	dir, err := os.ReadDir(current)
	if err != nil {
		return nil
	}

	if slices.ContainsFunc(dir, func(e os.DirEntry) bool {
		return e.IsDir() && e.Name() == ".git"
	}) {
		return []string{current}
	}

	var res []string
	for entry := range slices.Values(dir) {
		repos := findGitRepos(root, filepath.Join(current, entry.Name()), depth-1)
		res = append(res, repos...)
	}

	if len(res) > 0 {
		return res
	}
	if root != current {
		return nil
	}
	return []string{root}
}

func colorizePart(part string, bold bool) string {
	h := fnv.New64()
	h.Write([]byte(part))
	r := rand.New(rand.NewSource(int64(h.Sum64())))

	hue := num.NormalizeDegree(r.Float64()*360 + flagSeed)
	hct := color.Hct{
		Hue:    hue,
		Chroma: flagChroma,
		Tone:   flagTone,
	}
	colored := hct.ToARGB().AnsiFg(part)

	if bold {
		return "\x1b[1m" + colored
	}
	return colored
}

const sep = string(os.PathSeparator)

func colorizePath(path string) string {
	parts := strings.Split(path, sep)
	last := len(parts) - 1
	for i, part := range parts {
		parts[i] = colorizePart(part, i == last)
	}
	return strings.Join(parts, sep)
}

func find(root string, maxDepth int) []string {
	dir, err := os.ReadDir(root)
	if err != nil {
		return nil
	}

	var repos []string
	for entry := range slices.Values(dir) {
		if entry.IsDir() {
			path := filepath.Join(root, entry.Name())
			repos = append(repos, findGitRepos(path, path, maxDepth)...)
		}
	}

	slices.SortStableFunc(repos, func(a, b string) int {
		aSlashes := strings.Count(a, "/")
		bSlashes := strings.Count(b, "/")
		if aSlashes != bSlashes {
			return aSlashes - bSlashes
		}
		return strings.Compare(strings.ToLower(a), strings.ToLower(b))
	})

	for i, repo := range repos {
		repos[i] = colorizePath(should(filepath.Rel(root, repo)))
	}
	return repos
}

func main() {
	pflag.Float64VarP(&flagTone, "tone", "t", flagTone, "HCT tone (0–100)")
	pflag.Float64VarP(&flagChroma, "chroma", "c", flagChroma, "HCT chroma (0–100)")
	pflag.Float64VarP(&flagSeed, "seed", "s", flagSeed, "Seed for color randomness")
	pflag.IntVarP(&flagDepth, "max-depth", "d", flagDepth, "Maximum directory recursion depth")
	pflag.Parse()

	if pflag.NArg() != 1 {
		fmt.Fprintln(os.Stderr, "usage: list-repos [flags] <root>")
		pflag.PrintDefaults()
		os.Exit(1)
	}

	root := pflag.Arg(0)
	repos := find(root, int(flagDepth))

	for r := range slices.Values(repos) {
		fmt.Println(r)
	}
}
