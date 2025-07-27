package main

import (
	"os"
	"strings"
	"time"

	"github.com/carapace-sh/carapace"
	"github.com/carapace-sh/carapace/pkg/cache/key"
	"github.com/spf13/cobra"
)

func Lines(s []byte) []string {
	return strings.Split(strings.TrimSpace(string(s)), "\n")
}

var CarapaceAllPackage = carapace.ActionExecCommand("paru", "-Pc")(
	func(output []byte) carapace.Action {
		dc := []string{}
		for _, line := range Lines(output) {
			parts := strings.SplitN(line, " ", 2)
			dc = append(dc, parts...)
		}
		return carapace.ActionValuesDescribed(dc...)
	}).Cache(10*time.Second, key.String("pac-pkg"))

var CarapaceInstalledPackage = carapace.ActionExecCommand("pacman", "-Qq")(
	func(output []byte) carapace.Action {
		return carapace.ActionValues(Lines(output)...)
	})

var pacCmd = &cobra.Command{
	Use:          "pac",
	SilenceUsage: true,
	Short:        "A pacman/paru wrapper with extended utilities",
}

func main() {
	carapace.Gen(pacCmd).Standalone()
	if err := pacCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
