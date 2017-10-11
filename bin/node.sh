#!/bin/bash

set -euo pipefail

# Make sure nvm is installed first
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"  # This loads nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"

nvm install --lts
nvm use --lts

npm i -g yarn \
         localtunnel \
         nodemon \
         npm-check \
         nsp \
         trash-cli
