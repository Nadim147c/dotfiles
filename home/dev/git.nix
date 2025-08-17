# Why this setup?
# - By default Home Manager manages ~/.config/git/config. That file is
#   symlinked into the Nix store, so Git cannot write to it. Commands
#   like `git maintenance start` or `git config --global` will fail.
#
# - We want:
#     1. Declarative config under Nix (immutable, reproducible).
#     2. A writable config file for Git to mutate.
#     3. XDG compliance (use ~/.config/git/, not legacy ~/.gitconfig).
#
# - Solution:
#     * Home Manager writes immutable config to ~/.config/git/config.nix.
#     * ~/.config/git/config stays writable and includes config.nix.
#     * An activation script ensures migration and inclusion are correct.
#
# Effect:
# - Git sees ~/.config/git/config as its main config.
# - That file includes ~/.config/git/config.nix (Nix-managed).
# - Git can safely write to ~/.config/git/config without breaking Nix.
{
    config,
    pkgs,
    lib,
    ...
}: let
    gitConfigNix = "${config.xdg.configHome}/git/config.nix";
    gitConfig = "${config.xdg.configHome}/git/config";
in {
    # Ignore the default config: redirect Home Manager’s output into config.nix
    xdg.configFile."git/config".target = "git/config.nix";

    # Ensure Git always includes the Nix config
    home.activation.gitConfigInclude = lib.hm.dag.entryAfter ["writeBoundary"] # bash

    ''
        mkdir -p ${config.xdg.configHome}/git

        # Migrate legacy ~/.gitconfig to XDG if present
        if [ -f "$HOME/.gitconfig" ] && [ ! -f "${gitConfig}" ]; then
          echo "Migrating ~/.gitconfig → ${gitConfig}"
          mv -vf "$HOME/.gitconfig" "${gitConfig}"
        fi

        # If ~/.config/git/config doesn't exist, create it
        if [ ! -f "${gitConfig}" ]; then
          touch "${gitConfig}"
        fi

        # Check if config.nix is already included
        if ! ${pkgs.gitFull}/bin/git config --file="${gitConfig}" --get-all include.path \
            | grep -qx "${gitConfigNix}"; then
          echo "Adding include for ${gitConfigNix} in ${gitConfig}"
          ${pkgs.gitFull}/bin/git config --file="${gitConfig}" \
            --add include.path "${gitConfigNix}"
        fi
    '';

    programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings.git_protocol = "ssh";
    };

    programs.git = {
        package = pkgs.gitFull;
        enable = true;
        userName = "Ephemeral";
        userEmail = "theephemeral.txt@gmail.com";

        delta = {
            enable = true;
            options = {
                navigate = true;
                hunk-header-style = "omit";
                line-numbers = true;
            };
        };

        extraConfig = {
            init.defaultBranch = "main";

            core = {
                compression = 9;
                fsync = "none";
                whitespace = "error";
            };

            merge.conflictstyle = "diff3";

            diff = {
                colorMoved = "default";
                context = 3;
                renames = "copies";
                interHunkContext = 10;
            };

            commit = {
                verbose = true;
                gpgSign = true;
            };

            log = {
                abbrevCommit = true;
                graphColors = "blue,yellow,cyan,magenta,green,red";
            };

            status = {
                branch = true;
                short = true;
                showStash = true;
                showUntrackedFiles = "all";
            };

            color = {
                ui = true;
                blame.highlightRecent = "black bold,1 year ago,white,1 month ago,default,7 days ago,blue";
                branch.current = "magenta";
                branch.local = "default";
                branch.remote = "yellow";
                branch.upstream = "green";
                branch.plain = "blue";
            };

            push = {
                autoSetupRemote = true;
                default = "current";
                followTags = true;
                gpgSign = false;
            };

            pull.rebase = true;
            submodule.fetchJobs = 16;
            rebase.autoStash = true;
        };

        aliases = {
            tag-latest = "!f() { git tag -a \"$1\" -m \"Release: $1\"; } f";
            grep = "!rg --color=always --hidden --glob=!.git";
            fork = "!gh repo fork";
            find = "!fd --hidden --exclude=.git";
            acm = "!git add -A && git commit";

            st = "status";
            co = "checkout";
            cm = "commit";
            aa = "add -A";
            hard = "reset --hard";
            amend = "commit --amend";
            fast-clone = "clone --depth=1";
            down = "pull --rebase";
            open = "browse";
            dis = "diff --cached";

            lsignored = "ls-files . --ignored --exclude-standard --others";
            graph = "log --graph --all --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n   %C(bold)%C(green)%s%C(reset)'";
            vtag = "!git tag | sort -V";
        };

        extraConfig."git-extras" = {
            feature.prefix = "feat";
        };
    };
}
