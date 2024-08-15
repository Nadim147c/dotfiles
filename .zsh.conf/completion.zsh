autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit cdreplay -q

# History
export HISTSIZE=5000
export HISTFILE="$HOME/.local/share/zsh_history"
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':fzf-tab:*' fzf-flags '--ansi'
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept' 
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' popup-min-size 50 8
zstyle ':completion:*' menu no
zstyle ':completion:*' auto-descitiption 'specify: %d'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':completion::complete:*:*:files' ignored-patterns '.DS_Store' 'Icon?' '.Trash'
zstyle ':completion::complete:*:*:globbed-files' ignored-patterns '.DS_Store' 'Icon?' '.Trash'
zstyle ':completion::complete:rm:*:globbed-files' ignored-patterns

# print env
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

local default_delta='delta --line-numbers --file-style=omit --hunk-header-style=omit'
# Git Completions 
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
  "git diff --no-ext-diff \$word | $default_delta"
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
  "git --no-pager log --color=always --format=oneline --abbrev-commit --follow \$realpath 2>/dev/null || git show --color=always \$word | $default_delta"
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	"case \"\$group\" in
    'commit tag') git show --color=always \$word | $default_delta;;
    *) git show --color=always \$word | $default_delta ;;
	esac"
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	"case \"\$group\" in
    'modified file') git diff \$word | delta ;;
    'recent commit object name') git show --color=always \$word | delta ;;
    *) git log --color=always \$word ;;
	esac"

# Man Completions
zstyle ':fzf-tab:complete:man:*' fzf-preview \
  'man -P \"col -bx\" \$word | $FZF_PREVIEW_FILE_COMMAND --language=man'

# CD completion
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath'

# Kill process completion
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# SYSTEMD
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
