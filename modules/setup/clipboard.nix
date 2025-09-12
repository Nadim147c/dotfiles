{
    delib,
    host,
    pkgs,
    ...
}: let
    preview =
        # bash
        ''
            echo {} | rg -q "\[\[ binary data .+ .+ (png|jpeg|jpg|webm) \d+x\d+ \]\]" &&
                cliphist decode {1} | kitten icat --clear --silent \
                    --transfer-mode=memory --unicode-placeholder --stdin=yes \
                    --place="''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}@0x0" ||
                cliphist decode {1}
        '';
    cliphist-fzf = pkgs.writeShellApplication {
        name = "cliphist-fzf";
        excludeShellChecks = ["SC2016"];
        runtimeInputs = with pkgs; [
            bat
            cliphist
            coreutils
            fzf
            hyprland
            jq
            kitty
            ripgrep
            wl-clipboard
        ];
        text = ''
            fzf_source() {
              cliphist list | rg '(\d+)\t(.*)' --replace $'\e[1;31m$1\e[0m:'$'\e[1;32m$2\e[0m'
            }

            selected=$(
              fzf_source | fzf -d: \
                --preview '${preview}' \
                --with-shell "${pkgs.zsh}/bin/zsh -c" \
                --ansi --no-border --no-sort --reverse --preview-border=none \
                --bind "ctrl-x:execute(echo {1} | cliphist delete)+exclude"
            )

            if [[ -n "$selected" ]]; then
              id=$(echo "$selected" | cut -d: -f1)
              cliphist decode "$id" | wl-copy
              echo "Copied entry ID $id to clipboard."
            fi

            pid=$(hyprctl clients -j | jq -r '.[] | select(.class == "clipboard") | .pid')
            [[ -n "$pid" ]] && kill -9 "$pid"
        '';
    };

    clipboard-history-bin = pkgs.writeShellScriptBin "clipboard-history" ''
        ${pkgs.kitty}/bin/kitty --class=clipboard ${cliphist-fzf}/bin/cliphist-fzf
    '';

    clipboard-history = "${clipboard-history-bin}/bin/clipboard-history";
in
    delib.module {
        name = "setup.clipboard";

        options = delib.singleEnableOption host.isDesktop;

        home.ifEnabled = {
            home.packages = with pkgs; [
                clipboard-history-bin
                cliphist
                wl-clipboard
            ];

            services.cliphist = {
                enable = true;
                allowImages = true;
            };

            wayland.windowManager.hyprland.settings.bind = [
                "$mainMod, V, exec, ${clipboard-history}"
            ];

            programs.waybar.settings.main."custom/clipboard" = {
                format = "";
                tooltip-format = "Open clipboard history";
                on-click = clipboard-history;
            };
        };
    }
