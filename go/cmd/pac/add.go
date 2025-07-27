package main

import (
	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(addCmd)
	carapace.Gen(addCmd).PositionalAnyCompletion(CarapaceAllPackage)
}

var addCmd = &cobra.Command{
	Use:   "add [packages...]",
	Short: "Install packages if not already installed",
	Args:  cobra.MinimumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		return NewCommand("paru").Args("-S", "--needed").Args(args...).Execute()
	},
}
