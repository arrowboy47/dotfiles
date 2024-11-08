# setting zinit and plugin directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# download it if not already on system
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi

# load in zinit
source "${ZINIT_HOME}/zinit.zsh"

# using starship powerline
# pretty pastel file found ~/.config/starship.toml
eval "$(starship init zsh)"

# plugins 
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# plug ins from Oh my zsh
zinit snippet OMZP::command-not-found
zinit snippet OMZP::git
zinit snippet OMZP::aws
zinit snippet OMZP::sudo


# load in plugs
autoload -U compinit && compinit
# replays all cached completions
zinit cdreplay -q

# keybinds
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# vim mode mappings
bindkey -v

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-color "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd*' fzf-preview 'ls --color $realpath'



# Shell Integrations
# Set-up FZF key bindings (CTRL R for fuzzy history finder)
eval "$(fzf --zsh)"

eval "$(zoxide init --cmd cd zsh)"



# zsh history confs
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space # if a space is placed b4 a command it wont be writtin to history .00.
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# others
setopt extendedglob
setopt AUTO_CD




# vim binds for zsh
set -o vi
# lists wifi networks
alias wifils="nmcli d wifi list ifname wlan0"
# forces the use of nvim
alias v='nvim'
export EDITOR='nvim'

# c to clear
alias c="clear"
# ls to ls -la
alias l="ls -la --color"
# q to exit
alias q='exit'

alias vpn="protonvpn-cli"
alias tri="tree -I ".git" -a ."


export PATH="$HOME/.local/bin":$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"

function mkcd {
  if [ $# -eq 0 ]; then
    echo "Usage: mkcd directory_name"
  else
    mkdir -p "$1" && cd "$1"
  fi
}


[[ "$TERM_PROGRAM" == "vscode" ]] && command -v code > /dev/null && . "$(code --locate-shell-integration-path zsh)"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar e $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

