alias python="python3"
alias pip="pip3"

. "$HOME/.local/bin/env"
export PATH="$HOME/.cargo/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm use --lts > /dev/null 2>&1

# source antidote
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh

ZSH_THEME="awesomepanda"
# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTZIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

alias ls='ls --color'
eval "$(fzf --zsh)"

cf() {
    local dir
    dir=$(fd . --type d --max-depth 2 ~/Personal ~/Work ~/School ~/Documents | fzf --prompt "Choose a directory: " --preview 'tree -C -L 2 {}')
    if [ -n "$dir" ]; then
        cd "$dir" || return 1
    fi
}

# --- tmux project switcher / sessionizer ---
tmux-sessionizer() {
    local selected selected_name tmux_running

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(find ~/Work ~/Personal ~/School ~/Documents -mindepth 1 -maxdepth 2 -type d | fzf)
    fi

    if [[ -z $selected ]]; then
        return 0
    fi

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s "$selected_name" -c "$selected"
        return 0
    elif [[ -z $TMUX ]] && [[ -n $tmux_running ]]; then
        tmux attach-session -t "$selected_name" 2>/dev/null || tmux new-session -s "$selected_name" -c "$selected"
        return 0
    fi

    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected"
    fi

    tmux switch-client -t "$selected_name"
}

# --- bind Alt+f to tmux-sessionizer in zsh ---
tmux_sessionizer_widget() {
    tmux-sessionizer
    zle reset-prompt
}
zle -N tmux_sessionizer_widget
bindkey '^[f' tmux_sessionizer_widget
