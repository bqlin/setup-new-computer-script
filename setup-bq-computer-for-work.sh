#!/bin/bash

VERSION="v2.1.0"
#===============================================================================
# title           setup-new-computer.sh
# author          jkesler@vendasta.com
#                 https://github.com/joelkesler
#===============================================================================
#   A shell script to help with the quick setup and installation of tools and 
#   applications for new developers at Vendasta.
# 
#   Quick Instructions:
#
#   1. Make the script executable:
#      chmod +x ./setup-new-computer.sh
#
#   2. Run the script:
#      ./setup-new-computer.sh
#
#   3. Some installs will need your password
#
#   4. You will be promted to fill out your git email and name. 
#      Use the email and name you use for Github
#
#   5. Follow the Post Installation Instructions in the Readme:
README="https://github.com/bqlin/setup-new-computer-script#post-installation-instructions"
#  
#===============================================================================


#===============================================================================
#  Functions
#===============================================================================


printHeading() {
    printf "\n\n\n\e[0;36m$1\e[0m \n"
}

printDivider() {
    printf %"$COLUMNS"s |tr " " "-"
    printf "\n"
}

printError() {
    printf "\n\e[1;31m"
    printf %"$COLUMNS"s |tr " " "-"
    if [ -z "$1" ]      # Is parameter #1 zero length?
    then
        printf "     There was an error ... somewhere\n"  # no parameter passed.
    else
        printf "\n     Error Installing $1\n" # parameter passed.
    fi
    printf %"$COLUMNS"s |tr " " "-"
    printf " \e[0m\n"
}

printStep() {
    printf %"$COLUMNS"s |tr " " "-"
    printf "\nInstalling $1...\n";
    $2 || printError "$1"
}

printLogo() {
cat << "EOT"

        ___       __  ___
       / _ )___ _/  |/  /__ _____
      / _  / _ `/ /|_/ / _ `/ __/
     /____/\_, /_/  /_/\_,_/\__/
            /_/


    NOTE:
    You can exit the script at any time by
    pressing CONTROL+C a bunch
EOT
}

showIDEMenuLoop() {
    # from https://serverfault.com/a/777849
    printLogo
}

# Get root user for later. Brew needs the user to be admin to install 
sudo ls > /dev/null


#===============================================================================
# Installer: Settings
#===============================================================================


# Show IDE Selection Menu
clear
showIDEMenuLoop
printDivider


#===============================================================================
#  Installer: Set up shell profiles
#===============================================================================


# Create .bash_profile and .zprofile if they dont exist
# printHeading "Prep Bash and Zsh"
# printDivider
#     echo "✔ Touch ~/.bash_profile"
#         touch ~/.bash_profile
# printDivider
#     echo "✔ Touch ~/.zprofile"
#         touch ~/.zprofile
# printDivider
#     if grep --quiet "setup-new-computer.sh" ~/.bash_profile; then
#         echo "✔ .bash_profile already modified. Skipping"
#     else
#         writetoBashProfile
#         echo "✔ Added to .bash_profile"
#     fi
# printDivider
#     # Zsh profile
#     if grep --quiet "setup-new-computer.sh" ~/.zprofile; then
#         echo "✔ .zprofile already modified. Skipping"
#     else
#         writetoZshProfile
#         echo "✔ Added to .zprofile"
#     fi
# printDivider
#     echo "(zsh) Rebuild zcompdump"
#     rm -f ~/.zcompdump
# printDivider
#     echo "(zsh) Fix insecure directories warning"
#     chmod go-w "$(brew --prefix)/share"
# printDivider

printHeading "修改密码"
pwpolicy -clearaccountpolicies
printDivider
passwd
printDivider


#===============================================================================
#  Installer: Main Payload
#===============================================================================


# Install xcode cli development tools
printHeading "Installing xcode cli development tools"
printDivider
    xcode-select --install && \
        read -n 1 -r -s -p $'\n\nWhen Xcode cli tools are installed, press ANY KEY to continue...\n\n' || \
            printDivider && echo "✔ Xcode cli tools already installed. Skipping"
printDivider


# Install oh-my-zsh
printHeading "Install oh-my-zsh"
printDivider
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
printDivider
chsh -s /bin/zsh
printDivider
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
printDivider


# Install Brew
printHeading "Installing Homebrew"
printDivider
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
printDivider
    echo "✔ Setting Path to /usr/local/bin:\$PATH"
        export PATH=/usr/local/bin:$PATH
printDivider


# Install Utilities
printHeading "Installing Brew Packages"
    printStep "bash-completion"             "brew install bash-completion"
    printStep "zsh-completions"             "brew install zsh-completions"
    printStep "zsh-syntax-highlighting"     "brew install zsh-syntax-highlighting"
    printStep "tree"                        "brew install tree"
    printStep "carthage"                    "brew install carthage"
    printStep "wget"                        "brew install wget"
printDivider


# Install  Apps
printHeading "Installing Applications"
    printStep "iTerm2"                  "brew install --cask iterm2"
    printStep "Visual Studio Code"      "brew install --cask visual-studio-code"
    printStep "Sublime Text"            "brew install --cask sublime-text"
    printStep "Jetbrains Toolbox"       "brew install --cask jetbrains-toolbox"
printDivider


# Install Mac OS Python Pip and Packages
# Run this before "Homebrew Python 3" to make sure "Homebrew Python 3" will overwrite pip3
printHeading "Installing Mac OS Python"
    printDivider
        echo "Installing Pip for MacOS Python..."
            sudo -H /usr/bin/easy_install pip==20.3.4
    printDivider
        echo "Upgrading Pip for MacOS Python..."
            sudo -H pip install --upgrade "pip < 21.0"
    printStep "Invoke for MacOS Python"          "sudo -H pip install --quiet invoke"
    printStep "Requests for MacOS Python"        "sudo -H pip install --quiet requests"
    printStep "lxml for MacOS Python"            "sudo -H pip install --quiet lxml"
    printStep "pyCrypto for MacOS Python"        "sudo -H pip install --quiet pyCrypto"
    printStep "Virtualenv for MacOS Python"      "sudo -H pip install --quiet virtualenv"
printDivider


# Install Homebrew Python 3
printHeading "Installing Homebrew Python 3"
    printStep "Homebrew Python 3 with Pip"       "brew reinstall python"
printDivider


# Install Node
# printHeading "Installing Node and Angular CLI through NVM"
#     printDivider
#         getLastestNVM() {
#             # From https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
#             # Get latest release from GitHub api | Get tag line | Pluck JSON value
#             curl --silent "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | 
#                 grep '"tag_name":' |
#                 sed -E 's/.*"([^"]+)".*/\1/'
#         }
#         echo "✔ Current NVM is $(getLastestNVM)"
#     printDivider
#         echo "Installing NVM (Node Version Manager) $(getLastestNVM)..."
#         curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(getLastestNVM)/install.sh | bash
#     printDivider
#         echo "✔ Loading NVM into PATH"
#         export NVM_DIR="$HOME/.nvm"
#         [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#     printDivider
#         echo "Installing Node..."
#         nvm install 14
#     printStep "Angular CLI"             "npm install -g @angular/cli"
#     printStep "NX"                      "npm install -g nx"
#     printStep "Husky"                   "npm install -g husky"
#     printStep "Node Sass"               "npm install -g node-sass"
#     printStep "Node Gyp"                "npm install -g node-gyp"
#     printDivider
#         echo "✔ Touch ~/.huskyrc"
#             touch ~/.huskyrc
#     printDivider
#         # Husky profile
#         if grep --quiet "nvm" ~/.huskyrc; then
#             echo "✔ .huskyrc already includes nvm. Skipping"
#         else
#             writetoHuskrc
#             echo "✔ Add nvm to .huskyrc"
#         fi
# printDivider

# Install Other Commandline Tools
printHeading "System Tweaks"



# Install System Tweaks
printHeading "System Tweaks"
    printDivider
    echo "✔ General: Expand save and print panel by default"
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
    echo "✔ General: Save to disk (not to iCloud) by default"
        defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    echo "✔ General: Avoid creating .DS_Store files on network volumes"
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    printDivider
        
    echo "✔ Typing: Disable smart quotes and dashes as they cause problems when typing code"
        defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    echo "✔ Typing: Disable press-and-hold for keys in favor of key repeat"
        defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    printDivider

    echo "✔ Finder: Show status bar and path bar"
        defaults write com.apple.finder ShowStatusBar -bool true
        defaults write com.apple.finder ShowPathbar -bool true
    echo "✔ Finder: Disable the warning when changing a file extension"
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    echo "✔ Finder: Show the ~/Library folder"
        chflags nohidden ~/Library
    printDivider
        
    # echo "✔ Safari: Enable Safari’s Developer Settings"
    #     defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    #     defaults write com.apple.Safari IncludeDevelopMenu -bool true
    #     defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    #     defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
    #     defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
    # printDivider
    
    # echo "✔ Chrome: Disable the all too sensitive backswipe on Trackpads and Magic Mice"
    #     defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
    #     defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
    #     defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
    #     defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false
    # echo "✔ Chrome: Use the system print dialog and expand dialog by default"
    #     defaults write com.google.Chrome DisablePrintPreview -bool true
    #     defaults write com.google.Chrome.canary DisablePrintPreview -bool true
    #     defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
    #     defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true
# printDivider



#===============================================================================
#  Installer: Git
#===============================================================================


# Set up Git
# printHeading "Set Up Git"

# # Configure git to always ssh when dealing with https github repos
# git config --global url."git@github.com:".insteadOf https://github.com/

# printDivider
#     echo "✔ Set Git to store credentials in Keychain"
#     git config --global credential.helper osxkeychain
# printDivider
#     if [ -n "$(git config --global user.email)" ]; then
#         echo "✔ Git email is set to $(git config --global user.email)"
#     else
#         read -p 'What is your Git email address?: ' gitEmail
#         git config --global user.email "$gitEmail"
#     fi
# printDivider
#     if [ -n "$(git config --global user.name)" ]; then
#         echo "✔ Git display name is set to $(git config --global user.name)"
#     else
#         read -p 'What is your Git display name (Firstname Lastname)?: ' gitName
#         git config --global user.name "$gitName"
#     fi
# printDivider



#===============================================================================
#  Installer: Complete
#===============================================================================

printHeading "Script Complete"
printDivider

tput setaf 2 # set text color to green
cat << "EOT"

   ╭─────────────────────────────────────────────────────────────────╮
   │░░░░░░░░░░░░░░░░░░░░░░░░░░░ Next Steps ░░░░░░░░░░░░░░░░░░░░░░░░░░│
   ├─────────────────────────────────────────────────────────────────┤
   │                                                                 │
   │   There are still a few steps you need to do to finish setup.   │
   │                                                                 │
   │        The link below has Post Installation Instructions        │
   │                                                                 │
   └─────────────────────────────────────────────────────────────────┘

EOT
tput sgr0 # reset text
echo "Link:"
echo $README
echo ""
echo ""
tput bold # bold text
read -n 1 -r -s -p $'             Press any key to to open the link in a browser...\n\n'
open $README
tput sgr0 # reset text

echo ""
echo ""
echo "Please open a new terminal window to continue your setup steps"


exit
