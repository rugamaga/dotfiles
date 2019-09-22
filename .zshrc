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

# ------------------------- zplug plugins
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build:"zplug --self-manage"
zplug "chrissicool/zsh-256color", use:"zsh-256color.plugin.zsh"
zplug "eendroroy/alien", from:github, as:theme
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "mafredri/zsh-async", from:github
zplug "mollifier/anyframe"
zplug "jhawthorn/fzy", as:command, hook-build:"make"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:"fzf"
zplug "peco/peco", as:command, from:gh-r
zplug "monochromegane/the_platinum_searcher", as:command, from:gh-r, rename-to:"pt"
zplug "motemen/ghq", as:command, from:gh-r, rename-to:"ghq"
zplug "stedolan/jq", as:command, from:gh-r, rename-to:"jq"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

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
  eval "$(anyenv init - zsh)"
  alias nvim="PYENV_VERSION=neovim3 nvr -s --remote-silent"
fi
