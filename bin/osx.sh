#!/bin/bash

# Reduce transparency
defaults write com.apple.universalaccess reduceTransparency -int 1

# Disable dashboard
defaults write com.apple.dashboard enabled-state -int 1

# Trackpad: enable tap to click and secondary click
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -int 1

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -int 1
defaults write com.apple.universalaccess closeViewPanningMode -int 0

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
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15
defaults write -g KeyRepeat -int 2 # normal minimum is 2

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
# Terminal                                                                    #
###############################################################################

# Set terminal pro theme default
defaults write com.apple.Terminal "Default Window Settings" -string "IR_Black"
defaults write com.apple.Terminal "Startup Window Settings" -string "IR_Black"
defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"

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

# Kill all affected apps

for app in "Address Book" "Calendar" "Contacts" "cfprefsd" "Dashboard" "Dock" \
    "Finder" "Mail" "SystemUIServer" "Google Chrome" "iTunes" "Photos" ; do
    killall "$app" > /dev/null 2>&1
done
