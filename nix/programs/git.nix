{...}: {
    programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings.git_protocol = "ssh";
    };

    programs.git = {
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
