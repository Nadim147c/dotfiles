{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "git-gitlab-remote";
  partof = "programs.git";
  package = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [ gum ];
    text = /* bash */ ''
      # Order to search for existing remotes
      REMOTES=("origin" "github" "upstream")

      SOURCE_REMOTE=""

      for r in "''${REMOTES[@]}"; do
        if git remote get-url "$r" >/dev/null 2>&1; then
          SOURCE_REMOTE="$r"
          break
        fi
      done

      if [[ -z "$SOURCE_REMOTE" ]]; then
        echo "No source remote found (checked: origin, github, upstream)"
        exit 1
      fi

      SOURCE_URL=$(git remote get-url "$SOURCE_REMOTE")

      GITLAB_URL=$(echo "$SOURCE_URL" | sed -E 's#github\.com#gitlab.com#')

      gum confirm "Setting remote gitlab = $GITLAB_URL. Are you sure?" || exit 0

      if git remote get-url gitlab >/dev/null 2>&1; then
        git remote set-url gitlab "$GITLAB_URL"
        echo "🔄 Updated existing 'gitlab' remote → $GITLAB_URL"
      else
        git remote add gitlab "$GITLAB_URL"
        echo "✅ Added 'gitlab' remote → $GITLAB_URL"
      fi
    '';
  };
}
