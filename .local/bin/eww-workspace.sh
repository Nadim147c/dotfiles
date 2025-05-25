#!/bin/sh

SLEEP_TIME=0.5

LAST_UPDATE=0
TIMER_PID=""

handle_workspace() {
  current_time=$(date +%s)
  LAST_UPDATE=$current_time

  if [ -n "$TIMER_PID" ] && kill -0 $TIMER_PID 2>/dev/null; then
    kill $TIMER_PID 2>/dev/null
  fi

  eww open workspace_name

  (
    timer_start=$(date +%s)
    sleep $SLEEP_TIME
    if [ "$LAST_UPDATE" -le "$timer_start" ]; then
      eww close workspace_name
    fi
  ) &
  TIMER_PID=$!
}

handle() {
  case $1 in
    workspacev2*)
      handle_workspace 2>/dev/null
      ;;
  esac
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
  while read -r line; do handle "$line"; done
