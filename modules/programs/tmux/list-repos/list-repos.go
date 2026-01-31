package main

import (
	"fmt"
	"hash/fnv"
	"os"
	"path/filepath"
	"slices"
	"strings"

	"github.com/spf13/pflag"
)

func safeAbsolute(v, fallback string) (string, error) {
	if v == "" {
		return fallback, nil
	}
	return filepath.Abs(v)
}

func isDotGit(f os.DirEntry) bool {
	return f.IsDir() && f.Name() == ".git"
}

func findGitRepos(root, current string, depth int) []string {
	if depth < 0 {
		return nil
	}

	root, err := filepath.Abs(root)
	if err != nil {
		return nil
	}
	current, err = safeAbsolute(current, root)
	if err != nil {
		return nil
	}

	dir, err := os.ReadDir(current)
	if err != nil {
		return nil
	}

	if slices.ContainsFunc(dir, isDotGit) {
		return []string{current}
	}

	var res []string
	for entry := range slices.Values(dir) {
		if !entry.IsDir() {
			continue
		}
		repos := findGitRepos(root, filepath.Join(current, entry.Name()), depth-1)
		if repos != nil {
			res = append(res, repos...)
		}
	}

	if len(res) > 0 {
		return res
	}

	if root != current {
		return nil
	}

	return []string{root}
}

const baseAnsiIndex = 31

func colorizePart(part string, bold bool) string {
	h := fnv.New64()
	fmt.Fprint(h, part)
	idx := h.Sum64() % 6

	colored := fmt.Sprintf("\x1b[%dm%s\x1b[0m", baseAnsiIndex+idx, part)
	if bold {
		colored = "\x1b[1m" + colored
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
		if !entry.IsDir() {
			continue
		}
		path := filepath.Join(root, entry.Name())
		repos = append(repos, findGitRepos(path, path, maxDepth)...)
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
		rel, err := filepath.Rel(root, repo)
		if err != nil {
			continue
		}
		repos[i] = colorizePath(rel)
	}
	return repos
}

var flagDepth int = 5

func main() {
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
