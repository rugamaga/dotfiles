#!/bin/bash

# ------------ install packages for php-build
brew install autoconf
brew install bison
brew install bzip2
brew install curl
brew install icu4c
brew install libedit
brew install libjpeg
brew install libiconv
brew install libpng
brew install libxml2
brew install libzip
brew install openssl
brew install re2c
brew install tidy-html5
brew install zlib
brew install oniguruma

# ------------------------- install php
PKG_CONFIGS=(
  `brew --prefix krb5`/lib/pkgconfig
  `brew --prefix zlib`/lib/pkgconfig
  `brew --prefix libxml2`/lib/pkgconfig
  `brew --prefix openssl@1.1`/lib/pkgconfig
  `brew --prefix icu4c`/lib/pkgconfig
  `brew --prefix oniguruma`/lib/pkgconfig
  `brew --prefix libedit`/lib/pkgconfig
)
export PKG_CONFIG_PATH="${(j.:.)PKG_CONFIGS}:$PKG_CONFIG_PATH"

# ------------------------- install php
LATEST_PHP=`phpenv install --list | grep -v snapshot | grep -v master | sort -V | tail -1`
PHP_BUILD_CONFIGURE_OPTS="--with-libedit=$(brew --prefix libedit)" phpenv install -s $LATEST_PHP
