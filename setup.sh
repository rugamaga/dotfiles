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
rbenv install -s 2.5.3
rbenv global 2.5.3
gem install bundler

# ------------------------- install python
pyenv install -s 2.7.15
pyenv virtualenv 2.7.15 neovim2
pyenv shell neovim2
pip install neovim sexpdata websocket-client

pyenv install -s 3.7.1
pyenv virtualenv 3.7.1 neovim3
pyenv shell neovim3
pip install neovim sexpdata websocket-client

pyenv global 3.7.1

# ------------------------- install nodejs
ndenv install -s v11.1.0
ndenv global v11.1.0
