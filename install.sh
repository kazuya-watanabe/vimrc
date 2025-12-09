#!/usr/bin/env bash

set -euo pipefail

pushd "$(dirname "$0")" > /dev/null
SCRIPT_DIR="$(pwd -P)"
popd > /dev/null

if [ -h "$HOME/.vim" ]; then
    rm -f "$HOME/.vim"
elif [ -d "$HOME/.vim" ]; then
    mv "$HOME/.vim" "$HOME/.vim.$(date +%s)"
fi

ln -fs "$SCRIPT_DIR/.vim" "$HOME/.vim"
