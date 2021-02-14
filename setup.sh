#! /bin/bash

# ------------------------- setup global variables

# ----------- path

# ------------------------- collect variables
SETTINGS_ROOT=$(cd $(dirname $0); pwd)

read -p "input your name: " NAME
NAME=${NAME:-rugamaga}

read -p "input your email: " EMAIL
EMAIL=${EMAIL:-rugamaga@gmail.com}


# ------------------------- setup functions

# create if not file exists
# otherwise, don't touch.
function create_if_missing () {
  [[ -e "$1" ]] || cat - > "$1"
}

# ------------------------- install asdf
export TMPDIR="$HOME/.tmp"
mkdir -p $TMPDIR

[[ -s ~/.asdfrc ]] || ln -s ~/.asdfrc .asdfrc
[[ -d ~/.asdf ]] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf
(
  cd ~/.asdf
  git checkout "$(git describe --abbrev=0 --tags)"
)

. $HOME/.asdf/asdf.sh
asdf plugin add ruby
asdf plugin add python
asdf plugin add nodejs

# ------------------------- install ruby
LATEST_RUBY=`asdf list all ruby | grep -v - | tail -1`
asdf install ruby $LATEST_RUBY
asdf global ruby $LATEST_RUBY
gem install bundler
gem install neovim

# ------------------------- install python
LATEST_PYTHON2=`asdf list all python | grep -e "^\s*2\.[0-9]\+\.[0-9]\+$" | tail -1`
asdf install python $LATEST_PYTHON2
asdf global python $LATEST_PYTHON2
pip install pynvim

LATEST_PYTHON=`asdf list all python | grep -e "^\s*[0-9]\+\.[0-9]\+\.[0-9]\+$" | tail -1`
asdf install python $LATEST_PYTHON
asdf global python $LATEST_PYTHON
pip install pynvim

pip install --user pipenv

# install poetry (package bundler)
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# ------------------------- install nodejs
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
LATEST_NODEJS=`asdf list all nodejs | grep -v - | tail -1`
asdf install nodejs $LATEST_NODEJS
asdf global nodejs $LATEST_NODEJS
npm install -g typescript
npm install -g neovim
npm install -g typescript-language-server
npm install -g dockerfile-language-server-nodejs
npm install -g vim-language-server
npm install -g vscode-json-languageserver

# ------------------------- output template

# ------------ .zshrc

create_if_missing "$HOME/.zshrc" << EOS
# ------------------------- variables
# profiling mode
PROFILING=false

# dotfiles directory
export SETTINGS_ROOT="${SETTINGS_ROOT}"

# ------------------------- start profiling
if \$PROFILING; then
  zmodload zsh/zprof && zprof
fi

# ------------------------- load common config
source "${SETTINGS_ROOT}/.zshrc"

# ------------------------- environment specific configs

# (you can setup environment specific configs here)

# ------------------------- end profiling
if \$PROFILING ; then
  if (which zprof > /dev/null 2>&1) ;then
    zprof
  fi
fi
EOS

# ------------ .zshenv
create_if_missing "$HOME/.zshenv" << EOS
source $SETTINGS_ROOT/.zshenv
EOS

# ------------ .gitconfig
create_if_missing "$HOME/.gitconfig" << EOS
[user]
  email = ${EMAIL}
  name = ${NAME}

[include]
  path = ${SETTINGS_ROOT}/.gitconfig
EOS

# ------------ .config/nvim/init.vim
mkdir -p $HOME/.config/nvim/
create_if_missing "$HOME/.config/nvim/init.vim" << EOS
let g:python_host_prog = '$HOME/.asdf/installs/python/2.7.18/bin/python2'
let g:python3_host_prog = '$HOME/.asdf/installs/python/3.9.1/bin/python'

" ------------------------- load common
source ${SETTINGS_ROOT}/.nvimrc
EOS

# ------------------------- .tmux.conf
# TODO: if there exists external file importing method, use the method.
create_if_missing "$HOME/.tmux.conf" << EOS
set -g default-terminal "xterm-256color"
set-option -ga terminal-overrides ",xterm*:Tc:sitm=\E[3m"
EOS
