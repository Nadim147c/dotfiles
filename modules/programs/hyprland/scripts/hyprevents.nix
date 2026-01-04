{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "hyprevent";
  partof = "programs.hyprland";
  package = pkgs.writers.writeGoBin name { } /* go */ ''
    package main

    import (
    	"bufio"
    	"fmt"
    	"log"
    	"net"
    	"os"
    	"os/exec"
    	"slices"
    	"strings"
    )

    var (
    	// XdgRuntimeDir is the XDG runtime directory
    	XdgRuntimeDir = os.Getenv("XDG_RUNTIME_DIR")
    	// HIS is the Hyprland instance signature
    	HIS = os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")
    	// HyprlandSocket2 is the path to Hyprland's event socket
    	HyprlandSocket2 = fmt.Sprintf("%s/hypr/%s/.socket2.sock", XdgRuntimeDir, HIS)
    )

    func main() {
    	log.SetFlags(0)

    	if len(os.Args) < 2 || slices.Contains(os.Args[1:], "--help") {
    		log.Fatalf("Usage: %s [...events] <cmd>", os.Args[0])
    	}

    	events := os.Args[1 : len(os.Args)-1]
    	hook := os.Args[len(os.Args)-1]
    	log.Println("subscribed:", events)
    	log.Println("hook:", hook)

    	conn, err := net.Dial("unix", HyprlandSocket2)
    	if err != nil {
    		log.Fatal(err)
    	}

    	defer conn.Close()
    	scaner := bufio.NewScanner(conn)
    	for scaner.Scan() {
    		line := scaner.Text()
    		event, data, found := strings.Cut(line, ">>")
    		if !found || len(events) != 0 && !slices.Contains(events, event) {
    			continue
    		}
    		cmd := exec.Command(hook, event, data)
    		cmd.Stdout = os.Stdout
    		cmd.Stderr = os.Stderr
    		cmd.Run()
    	}
    	if err := scaner.Err(); err != nil {
    		log.Fatal(err)
    	}
    }
  '';
}
