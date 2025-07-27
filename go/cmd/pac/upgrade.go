package main

import (
	"github.com/carapace-sh/carapace"
	"github.com/spf13/cobra"
)

func init() {
	pacCmd.AddCommand(upgradeCmd)
	carapace.Gen(upgradeCmd).PositionalAnyCompletion(CarapaceAllPackage)
}

var upgradeCmd = &cobra.Command{
	Use:     "upgrade [packages...]",
	Aliases: []string{"upg"},
	Short:   "Upgrade packages",
	RunE: func(cmd *cobra.Command, args []string) error {
		return NewCommand("paru").Args("-Syu").Args(args...).Execute()
	},
}
