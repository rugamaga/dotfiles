#!/bin/bash

# ------------ brew

# package management for appstore
brew install mas

# basic tools
brew install curl
brew install git
brew install nkf
brew install zsh
brew install vim
brew install ripgrep
brew install termshark

# for development audio application with rust...
brew install cmake
brew install pkg-config
brew install portaudio

# for development languages
brew install llvm
brew install haskell-stack

# ------------ brew cask
brew cask install alfred
brew cask install iterm2
brew cask install hyperswitch
brew cask install marp
brew cask install gas-mask
brew cask install virtualbox
brew cask install vagrant
brew cask install docker

# ------------ mas
mas install 441258766 # Magnet
mas install 425424353 # The Unarchiver
mas install 414855915 # WinArchiver Lite
mas install 539883307 # LINE
mas install 405399194 # Kindle

# ------------ rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
rustup component add rustfmt
rustup component add clippy
rustup component add rls rust-analysis rust-src

# ------------ scala
# metals(scala language server)
curl -L -o coursier https://git.io/coursier
chmod +x coursier
./coursier bootstrap \
  --java-opt -Xss4m \
  --java-opt -Xms100m \
  --java-opt -Dmetals.client=coc.nvim \
  org.scalameta:metals_2.12:0.7.6 \
  -r bintray:scalacenter/releases \
  -r sonatype:snapshots \
  -o /usr/local/bin/metals-vim -f
rm -f coursier
