#! /bin/sh

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
" ------------------------- load common
source ${SETTINGS_ROOT}/.nvimrc
EOS
