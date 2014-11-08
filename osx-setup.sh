# Ask for the administrator password upfront
sudo -v
 
# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#############################
# Display
#############################

# Enabling HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

#############################
# Mouse & Keyboard
#############################

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Enabling keyboard in all dialogs etc. Like tab
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

#############################
# Finder
#############################

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Default view mode: icons=`icnv`, list=`Nlsv`, columns=`clmv`, flow=`Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show hidden files & folders
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder AppleShowAllFiles TRUE

# Save to disk as default instead of to icloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Allowing text selection in Quick Look/Preview in Finder by default
defaults write com.apple.finder QLEnableTextSelection -bool true

#############################
# Dock & Dashboard
#############################

# Move the dock to the right side of the screen
# Possible values: "left", "bottom", "right"
defaults write com.apple.dock orientation -string "bottom"

# Move the dock to the end of the screen
# Possible values: "end", "middle", "start"
defaults write com.apple.dock pinning -string "end"

# Make dock icons not bounce
defaults write com.apple.dock no-bouncing -bool true

# Disable dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

#############################
# Terminal
#############################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Set theme
open "$HOME/.dotfiles/raksooo.terminal"
sleep 1 # Wait a bit to make sure the theme is loaded
defaults write com.apple.terminal "Default Window Settings" -string "raksooo"
defaults write com.apple.terminal "Startup Window Settings" -string "raksooo"

#############################
# Other applications
#############################

# Makes quicktime autoplay videos when opened
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

#############################
# Kill affected applications
#############################

for app in "Dock" "Finder" "SystemUIServer" "Terminal"; do
    killall "$app" > /dev/null 2>&1
done
