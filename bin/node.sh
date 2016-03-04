#!/bin/bash

# Make sure nvm is installed first
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"  # This loads nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

nvm install node

npm install -g babel-eslint caniuse-cmd eslint eslint-plugin-react standard tldr

npm update -g
