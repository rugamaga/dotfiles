# ------------------------- zplugin modules
if [[ ! -d ~/.zplugin/bin/zmodules/Src  ]]; then
  module_path+=( "~/.zplugin/bin/zmodules/Src" )
  zmodload zdharma/zplugin
fi

# ------------------------- variables

# ----------- locale
export LANGUAGE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8

# ----------- local
export HOME_LOCAL="${HOME}/.local/"

# ----------- man
export MANPATH="${HOME_LOCAL}/man:/usr/local/man:${MANPATH}"

# ----------- editor
export EDITOR="\\nvim"

# ----------- golang
export GOPATH=$HOME

# ----------- python
export PIPENV_VENV_IN_PROJECT=true

# ----------- prompt setting
export USE_NERD_FONT=1
export ALIEN_THEME="green"
export ALIEN_DATE_TIME_FORMAT='%Y/%m/%d %H:%M:%S'

# ----------- path
export PATH="${HOME}/.anyenv/bin:$HOME/.cargo/bin:${HOME}/bin:${HOME}/.local/bin:/usr/local/bin:${PATH}"

# ------------------------- zplugin

# auto install zplugin
if [[ ! -d ~/.zplugin/bin ]]; then
  mkdir -p ~/.zplugin
  git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
fi

declare -A ZPLGM
ZPLGM[COMPINIT_OPTS]=-C
source "$HOME/.zplugin/bin/zplugin.zsh"

# auto install zplugin module
if [[ ! -d ~/.zplugin/bin/zmodules/Src ]]; then
  zplugin module build
fi

zplugin light eendroroy/alien

zplugin ice wait"0" lucid; zplugin light mollifier/anyframe

zplugin ice wait"0" lucid as"program" from"gh-r" mv"fzf-* -> fzf"; zplugin light junegunn/fzf-bin
zplugin ice wait"0" lucid as"program" from"gh-r" pick"*/ghq"; zplugin light motemen/ghq
zplugin ice wait"0" lucid as"program" from"gh-r" mv"jq-* -> jq"; zplugin light stedolan/jq

zplugin ice wait"0" lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=true

zplugin ice wait"0" lucid atinit"zpcompinit; zpcdreplay"
zplugin light zdharma/fast-syntax-highlighting

# ------------------------- basic options
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_verify
setopt hist_reduce_blanks
setopt extended_glob

# ------------------------- functions

# changes buffer current directory when changed neovim terminal current directory.
function neovim_autocd() {
  [[ $NVIM_LISTEN_ADDRESS ]] && ${SETTINGS_ROOT}/bin/neovim-autocd.py
}

# ------------------------- events
chpwd_functions+=( neovim_autocd )

# ------------------------- key binding

# ----------- viins
bindkey -v
bindkey -v '^?' backward-delete-char

# ----------- history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# ----------- anyframe
bindkey '^r' anyframe-widget-cd-ghq-repository

# ------------------------- eval envs
if [ -x "$(command -v anyenv)" ]; then
  eval "$(anyenv init - --no-rehash zsh)"
  alias nvim="PYENV_VERSION=neovim3 nvr -s --remote-silent"
fi
