package main

import (
	"os"
	"os/exec"
)

type Command struct {
	cmd *exec.Cmd
}

func NewCommand(name string) *Command {
	cmd := exec.Command(name)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return &Command{cmd}
}

func (c *Command) Args(args ...string) *Command {
	c.cmd.Args = append(c.cmd.Args, args...)
	return c
}

func (c *Command) Execute() error {
	return c.cmd.Run()
}
