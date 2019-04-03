#!/bin/bash

set -euo pipefail

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for sudo up front
sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

############
### brew ###
############

export HOMEBREW_NO_AUTO_UPDATE=1

# Make sure homebrew is installed first
if [[ ! "$(type -P brew)" ]]; then
    echo "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Updating Homebrew"

brew doctor
brew update

echo "Installing brew packages"

# cli

## shell

brew install zsh
brew install zsh-completions

## version control

brew install git

## internet utils

brew install wget
brew install curl

## db

brew install postgresql

## misc utilities

brew install ghostscript
brew install openssl
brew install terraform
brew install vault
brew install awscli
brew install nvm

mkdir -p ~/.nvm

if ! grep -q "export NVM_DIR" ~/.zshrc; then
cat <<EOF >>~/.zshrc

export NVM_DIR="\$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
EOF
fi

echo "Installing brew cask packages"

# brew cask

brew tap caskroom/cask

## browsing

brew cask install google-chrome

## entertainment

brew cask install spotify
brew cask install aerial

## communication

brew cask install caprine
brew cask install slack

## security

brew cask install 1password
brew cask install tunnelblick

## devtools

brew cask install postico
brew cask install docker
brew cask install docker-toolbox
brew cask install visual-studio-code

## other

brew cask install alfred
brew cask install dropbox

brew cleanup

#############
### shell ###
#############

echo "Setting up shell"


if ! grep -q "share_history" ~/.zshrc; then
cat <<EOF >>~/.zshrc

unsetopt share_history
EOF
fi

######################
### macOS defaults ###
######################

echo "Setting up macOS defaults"

# Reduce transparency
sudo defaults write com.apple.universalaccess reduceTransparency -bool true

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable dashboard
defaults write com.apple.dashboard enabled-state -int 1

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Trackpad: enable tap to click and secondary click
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -int 1

# Use scroll gesture with the Ctrl (^) modifier key to zoom
sudo defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
sudo defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
sudo defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Show icons for hard drives, servers and removable media on the desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -int 1
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -int 1
defaults write com.apple.finder ShowMountedServersOnDesktop -int 1
defaults write com.apple.finder ShowRemovableMediaOnDesktop -int 1

# Disable automatic spelling correction
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Set the icon size of Dock items to 34 or 48 pixels depending on screen size
resolution=$(system_profiler SPDisplaysDataType | grep Resolution)
width=$(echo $resolution | cut -d ' ' -f 2)
height=$(echo $resolution | cut -d ' ' -f 4)

if [[ $(echo $resolution | cut -d ' ' -f 5) == 'Retina' ]]; then
    width=$(echo $width/2 | bc)
    height=$(echo $height/2 | bc)
fi

if [ "$height" -gt "1000" ]; then
    defaults write com.apple.dock tilesize -int 48
else
    defaults write com.apple.dock tilesize -int 34
fi

# Speed up key repeats
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1

# Hot corners
# Bottom left screen corner → Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Start Screen Saver
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0

# Autohide dock
defaults write com.apple.dock autohide -bool true

# Disable character accent menu
defaults write -g ApplePressAndHoldEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Allow items from unidentified developers to open
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true
# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Show the battery percentage in the menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Require password immediately after the computer went into
# sleep or screen saver mode
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Don't show recent tags
defaults write com.apple.finder ShowRecentTags -bool false

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Set New Finder Window to home folder 
defaults write com.apple.finder NewWindowTarget PfHm

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

###############################################################################
# Mail                                                                        #
###############################################################################

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# VSCode                                                                      #
###############################################################################

# Fix font rendering in VSCode
defaults write com.microsoft.VSCode.helper CGFontRenderingFontSmoothingDisabled -bool NO

################
### dotfiles ###
################

echo "Installing dotfiles"

for file in ".bashrc" ".gitattributes" ".gitconfig" ".gitignore" ".inputrc" ; do
    curl "https://raw.githubusercontent.com/johansteffner/dotfiles/master/home/$file" --output "$HOME/$file"
done

# Kill all affected apps
echo "Restart affected apps"

for app in "Address Book" "Calendar" "Contacts" "cfprefsd" "Dashboard" "Dock" \
    "Finder" "Mail" "SystemUIServer" "Google Chrome" "iTunes" "Photos" ; do
    killall "$app" > /dev/null 2>&1
done
