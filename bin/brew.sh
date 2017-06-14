#!/bin/bash

set -euo pipefail

# Make sure homebrew is installed first
if [[ ! "$(type -P brew)" ]]; then
    echo "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew doctor
brew update

# cli

## shell

brew install zsh

## version control

brew install git

## internet utils

brew install wget
brew install curl

## image utils

brew install imagemagick
brew install graphicsmagick
brew install libmagic

## db

brew install postgresql
brew install ephemeralpg

## misc cli utilities

brew install ghostscript
brew install ansible
brew install openssl
brew install python
brew install python3
brew install the_silver_searcher

## aws utilities

brew install terraform
brew install awscli

# brew cask

brew tap caskroom/cask

## browsing

brew cask install google-chrome

## entertainment

brew cask install spotify
brew cask install aerial

## communication

brew cask install skype
brew cask install caprine
brew cask install slack

## security

brew cask install 1password

## devtools

brew cask install zeplin
brew cask install postico
brew cask install vmware-fusion
brew cask install virtualbox
brew cask install docker-toolbox
brew cask install atom
brew cask install visual-studio-code
brew cask install github-desktop

## other

brew cask install flux
brew cask install spectacle
brew cask install alfred
brew cask install dropbox
brew cask install google-drive

brew cleanup
