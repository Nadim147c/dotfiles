{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "tmux-sessionizer";
  partof = "programs.tmux";
  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      coreutils-full
      eza
      fzf
    ];
    text = ''
      # Pick repo with fd + fzf
      repo=$(list-repos "$HOME/git" | fzf --ansi --preview "eza ~/git/{}/ --tree --icons=always --color=always")

      # Exit if nothing was selected
      [ -z "$repo" ] && exit 0

      # Strip ANSI colors, get absolute path
      path="$HOME/git/$repo"
      name=$(echo -n "$repo" | tr : '|')

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
      tmux new-session -d -s "$name" -c "$path" "fish -c 'nvim; exec fish'"

      # Create a second window in the same path
      tmux new-window -t "$name:" -c "$path"

      # Switch into it
      if [ -n "''${TMUX-}" ]; then
          tmux switch-client -t "$name"
      else
          tmux attach -t "$name"
      fi
    '';
  };

}
