#!/bin/bash

# echo colors
PURPLE='\x1B[0;35m'
NO_COLOR='\x1B[0m'

echo -e "${PURPLE}Checking if homebrew is installed...${NO_COLOR}"

if test ! $(which brew); then
  echo -e "${PURPLE}Installing homebrew...${NO_COLOR}"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo -e "${PURPLE}Installing CocoaPods...${NO_COLOR}"

# install iOS apps dependency manager
sudo gem install cocoapods

# install CocoaPods Keys plugin
sudo gem install cocoapods-keys

brew update

# install brew apps from backup file

brewAppsFile=Backup/brewAppsList.txt

while read app; do
echo -e "${PURPLE}\nInstalling $app...${NO_COLOR}"
brew install $app
done < $brewAppsFile

brew install mas

# install AppStore apps from backup file

appstoreAppsFile=Backup/appstoreAppsList.txt

while read app; do
    app_id=$(echo $app | cut -d '#' -f 1)
    app_name=$(echo $app | cut -d '#' -f 2-)
echo -e "${PURPLE}\nInstalling $app_name (ID: $app_id)...${NO_COLOR}"
    mas install $app_id
done < $appstoreAppsFile


echo -e "${PURPLE}Setting user defaults...${NO_COLOR}"

# keep Xcode and Simulator on the same page
defaults write com.apple.iphonesimulator AllowFullscreenMode -bool YES

# indicate hidden app dock icons
defaults write com.apple.dock showhidden -bool TRUE; killall Dock

# remove all dock icons except Finder
defaults write com.apple.dock persistent-apps -array

# stop Photos from opening automatically (for all devices)
defaults write com.apple.ImageCapture disableHotPlug -bool YES

# no more asking for password during every Xcode build
DevToolsSecurity -enable


