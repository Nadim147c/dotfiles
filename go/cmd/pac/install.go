package main

import (
	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(installCmd)
	carapace.Gen(installCmd).PositionalAnyCompletion(CarapaceAllPackage)
}

var installCmd = &cobra.Command{
	Use:     "install [packages...]",
	Aliases: []string{"in"},
	Short:   "Install packages",
	Args:    cobra.MinimumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		return NewCommand("paru").Args("-S").Args(args...).Execute()
	},
}
