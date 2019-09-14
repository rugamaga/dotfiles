#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)/vscode
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User

mkdir -p "${VSCODE_SETTING_DIR}"

rm -f "$VSCODE_SETTING_DIR/settings.json"
ln -s "$SCRIPT_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"

rm -f "$VSCODE_SETTING_DIR/keybindings.json"
ln -s "$SCRIPT_DIR/keybindings.json" "${VSCODE_SETTING_DIR}/keybindings.json"

# install extention
cat vscode/extensions | while read line
do
 code --install-extension $line
done

code --list-extensions > vscode/extensions
