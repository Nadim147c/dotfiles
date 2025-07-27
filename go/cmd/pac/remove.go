package main

import (
	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(removeCmd)
	carapace.Gen(removeCmd).PositionalAnyCompletion(CarapaceInstalledPackage)
}

var removeCmd = &cobra.Command{
	Use:     "remove [packages...]",
	Aliases: []string{"rm"},
	Short:   "Uninstall packages",
	Args:    cobra.MinimumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		return NewCommand("paru").Args("-Rs").Args(args...).Execute()
	},
}
