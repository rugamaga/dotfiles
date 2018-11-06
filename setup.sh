#! /bin/sh

# ------------------------- setup global variables

# ----------- path
# use anyenv
export PATH="${PATH}:${HOME}/.anyenv/bin"

# ------------------------- collect variables
SETTINGS_ROOT=$(cd $(dirname $0); pwd)

read -p "input your name: " NAME
NAME=${NAME:-rugamaga}

read -p "input your email: " EMAIL
EMAIL=${EMAIL:-rugamaga@gmail.com}


# ------------------------- output template

# ------------ .zshrc

cat << EOS > $HOME/.zshrc
# ------------------------- variables
# dotfiles directory
export SETTINGS_ROOT="${SETTINGS_ROOT}"

# (setup environment specific settings here)

# ------------------------- load common
source "${SETTINGS_ROOT}/.zshrc"
EOS

# ------------ .gitconfig
cat << EOS > $HOME/.gitconfig
[user]
  email = ${EMAIL}
  name = ${NAME}

[include]
  path = ${SETTINGS_ROOT}/.gitconfig
EOS

# ------------ .config/nvim/init.vim
mkdir -p $HOME/.config/nvim/
cat << EOS > $HOME/.config/nvim/init.vim
let g:python_host_prog = '$HOME/.anyenv/envs/pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '$HOME/.anyenv/envs/pyenv/versions/neovim3/bin/python'

" ------------------------- load common
source ${SETTINGS_ROOT}/.nvimrc
EOS

# ------------------------- install anyenv
export TMPDIR="$HOME/.tmp"
mkdir -p $TMPDIR

git clone https://github.com/riywo/anyenv ~/.anyenv
mkdir -p ~/.anyenv/envs
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

anyenv install -s rbenv
anyenv install -s pyenv
anyenv install -s ndenv

git clone https://github.com/pyenv/pyenv-virtualenv.git $(anyenv root)/envs/pyenv/plugins/pyenv-virtualenv

# ------------------------- eval envs
if [ -x "$(command -v anyenv)" ]; then
  eval "$(anyenv init - zsh)"
fi

# ------------------------- install ruby
LATEST_RUBY=`rbenv install --list | grep -v - | tail -1`
rbenv install -s $LATEST_RUBY
rbenv global $LATEST_RUBY
gem install bundler

# ------------------------- install python
LATEST_PYTHON2='2.7.15'
pyenv install -s $LATEST_PYTHON2
pyenv virtualenv $LATEST_PYTHON2 neovim2
pyenv shell neovim2
pip install neovim sexpdata websocket-client

LATEST_PYTHON=`pyenv install --list | grep -v - | tail -1`
pyenv install -s $LATEST_PYTHON
pyenv virtualenv $LATEST_PYTHON neovim3
pyenv shell neovim3
pip install neovim sexpdata websocket-client

pyenv global $LATEST_PYTHON

# ------------------------- install nodejs
LATEST_NODEJS=`ndenv install --list | grep -v - | tail -1`
ndenv install -s $LATEST_NODEJS
ndenv global $LATEST_NODEJS
