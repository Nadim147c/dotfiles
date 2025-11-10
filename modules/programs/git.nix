{
    constants,
    delib,
    edge,
    pkgs,
    ...
}:
delib.module {
    name = "programs.git";

    options = delib.singleEnableOption true;

    home.ifEnabled = {
        home.packages =
            (with pkgs; [
                git-open
                lazygit
            ])
            ++ (with edge; [
                git-cliff
                git-extras
                svu
            ]);

        programs.gh = {
            enable = true;
            gitCredentialHelper.enable = true;
            settings.git_protocol = "ssh";
        };

        programs.git = {
            package = pkgs.gitFull;
            enable = true;
            userName = constants.fullname;
            userEmail = constants.email;

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

                branch.sort = "-committerdate";
                tag.sort = "version:refname";

                merge.conflictstyle = "diff3";

                fetch.fsckObjects = true;
                receive.fsckObjects = true;
                transfer.fsckObjects = true;

                interactive.singlekey = true;

                pack = {
                    threads = 0; # use all available threads
                    windowMemory = "1g"; # use 1g of memory for pack window
                    packSizeLimit = "1g"; # max size of a packfile
                };

                diff = {
                    algorithm = "histogram";
                    colorMoved = "default";
                    context = 3;
                    interHunkContext = 10;
                    mnemonicPrefix = true;
                    renames = "copies";
                };

                commit = {
                    gpgSign = true;
                    verbose = true;
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

                    branch = {
                        current = "magenta";
                        local = "default";
                        remote = "yellow";
                        upstream = "green";
                        plain = "blue";
                    };

                    diff = {
                        meta = "black bold";
                        frag = "magenta";
                        context = "white";
                        whitespace = "yellow reverse";
                        old = "red";
                    };

                    decorate = {
                        HEAD = "red";
                        branch = "blue";
                        tag = "yellow";
                        remoteBranch = "magenta";
                    };
                };

                push = {
                    autoSetupRemote = true;
                    default = "current";
                    followTags = true;
                    gpgSign = false;
                };

                fetch.prune = true;

                rerere = {
                    enabled = true;
                    autoupdate = true;
                };

                rebase = {
                    autoSquash = true;
                    autoStash = true;
                    updateRefs = true;
                    missingCommitsCheck = "warn";
                };

                url = {
                    "git@github.com:Nadim147c/".insteadOf = "me:";
                    "git@github.com:".insteadOf = "gh:";
                    "ssh://aur@aur.archlinux.org/".insteadOf = "aur:";
                };

                help.autocorrect = "prompt";
                pull.rebase = true;
                submodule.fetchJobs = 16;
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
                dis = "diff --cached";

                lsignored = "ls-files . --ignored --exclude-standard --others";
                graph = "log --graph --all --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n   %C(bold)%C(green)%s%C(reset)'";
                vtag = "!git tag | sort -V";
            };

            extraConfig."git-extras" = {
                feature.prefix = "feat";
            };
        };
    };
}
