{
  writeShellApplication,
  fzf,
  fd,
  tmux,
  eza,
}:
writeShellApplication {
  name = "tmux-sessionizer";

  runtimeInputs = [fzf fd tmux eza];

  text = ''
    # Pick project with fd + fzf
    project=$(fd --base-directory "$HOME" . git --max-depth 1 --min-depth 1 --color=always |
        fzf --ansi --preview "eza ~/{}/ --tree --icons --color=always")

    # Exit if nothing was selected
    [ -z "$project" ] && exit 0

    # Strip ANSI colors, get absolute path
    path="$HOME/$project"
    name=$(basename "$path")

    # If session already exists, reuse it
    if tmux has-session -t "$name" 2>/dev/null; then
        if [ -n "''${TMUX-}" ]; then
            # Inside tmux: detach and attach to the target session
            tmux switch-client -t "$name"
        else
            tmux attach -t "$name"
        fi
    fi

    # Otherwise, create a new session
    tmux new-session -d -s "$name" -c "$path" -n "Neovim" "nvim"

    # Create a second window in the same path
    tmux new-window -t "$name:" -c "$path"

    # Switch into it
    if [ -n "''${TMUX-}" ]; then
        tmux switch-client -t "$name"
    else
        tmux attach -t "$name"
    fi
  '';
}
