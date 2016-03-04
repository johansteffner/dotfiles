#!/bin/bash

# Make sure homebrew is installed first
if [[ ! "$(type -P brew)" ]]; then
    echo "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew doctor
brew update


# misc cli utilities
brew install bash-completion
brew install git
brew install imagemagick
brew install pyenv
brew install wget
brew install curl

brew tap caskroom/cask

# browsing
brew cask install google-chrome

# entertainment
brew cask install spotify

# communication
brew cask install skype

# security
brew cask install 1password

# devtools
brew cask install zeplin
brew cask install sequel-pro
brew cask install postico
brew cask install vmware-fusion
brew cask install virtualbox

# other
brew cask install flux


brew cleanup
brew cask cleanup
