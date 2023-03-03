#!/usr/bin/env bash

INFO() {
    echo 2>&1 "INFO: $@"
}
WARN() {
    echo 2>&1 "WARN: $@"
}
ERROR() {
    echo 2>&1 "ERROR: $@" && exit 1
}

CONFIRM_Y="[Yy]"
CONFIRM_N="[Nn]"

# This script must be executed from within the .dotfiles directory
INSTALL_DIR=$(pwd -P)
[[ $(basename ${INSTALL_DIR}) != ".dotfiles" ]] && ERROR "Please execute script from .dotfiles directory"
DOTFILES=(
    .bashrc .zshrc .environment
    .tmux.conf .tmux.conf.local .vimrc
    .config/starship.toml
    .config/nvim
    .config/alacritty
)

# Bootstrap installations
read -p "Skip bootstrapping requirements? [Y/n]: " SKIP_BOOTSTRAP
if [[ ${GENERATE_KEY} =~ ${CONFIRM_Y} ]]; then
    WARN "Skipping bootstrapping. Some things may not work if requirements aren't installed."
else
    ./bootstrap.sh
fi


# Make backups of current dotfiles
MAKE_BACKUPS() {
    mkdir ~/.dotfiles_backup
    for dotfile in ${DOTFILES[@]}; do
        [[ -f ~/${dotfile} ]] && cp -L ~/${dotfile} ~/.dotfiles_backup && rm -f ~/${dotfile}
    done
}
if [[ -d ~/.dotfiles_backup ]]; then
    read -p ".dotfiles_backup already exists! Overwrite? [Y/n]: " OVERWRITE
    if [[ ${OVERWRITE} =~ ${CONFIRM_Y} ]]; then
        rm -rf ~/.dotfiles_backup
        MAKE_BACKUPS
    else
        INFO "Won't overwrite ~/.dotfiles_backup"
    fi
else
    MAKE_BACKUPS
fi

# Symlink dotfiles
INFO "Symlinking dotfiles..."
for dotfile in ${DOTFILES[@]}; do
    src=${INSTALL_DIR}/${dotfile}
    dest=${HOME}/${dotfile}
    INFO "Linking from $src to $dest"
    if [[ -L "$dest" ]]; then
        INFO "$dest is already linked; skipping"
        continue
    fi
    if [[ $(dirname ${dotfile}) != '.' && ! -d ~/$(dirname ${dotfile}) ]]; then
        INFO "Making directory ~/$(dirname ${dotfile})"
        mkdir -p ~/$(dirname ${dotfile})
    fi
    ln -s "${src}" "${dest}"
done

# Generate SSH key
read -p "Generate SSH key? [Y/n]: " GENERATE_KEY
if [[ ${GENERATE_KEY} =~ ${CONFIRM_Y} ]]; then
    if [ ! -f ~/.ssh/id_rsa ]; then
        read -p "Specify email ID for key: " SSH_EMAIL_COMMENT
        KEYGEN_CMD=( "ssh-keygen" "-t" "rsa" "-b" "4096" "-C" "${SSH_EMAIL_COMMENT}" )
        INFO ${KEYGEN_CMD}
        ${KEYGEN_CMD}
        eval "$(ssh-agent -s)"
    else
        WARN "~/.ssh/id_rsa already exists, won't create a new key"
    fi
else
    INFO "Won't generate SSH key"
fi

# If using macOS, get Homebrew
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
INFO "Currently using a ${machine} OS"

if [ ${machine} == "Mac" ]; then

    # Don't create .DS_Store on network drives
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

    # Mac specific SSH config
    if ! grep -Fxq "Host *" ~/.ssh/config; then
        INFO "Updating SSH config"
        echo "Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa
    " >> ~/.ssh/config
        ssh-add -K ~/.ssh/id_rsa
    fi

    # Homebrew
    BREW_INSTALL_TARGETS=(
        cmake
        coreutils
        grip
        ripgrep
        tmux
    )

    INFO "Requesting to install the following brew targets:"
    INFO "${BREW_INSTALL_TARGETS[@]}"
    read -p "Install homebrew and brew packages? [Y/n]: " INSTALL_BREW

    if [[ ${INSTALL_DIR} =~ ${CONFIRM_Y} ]]; then
        if ! command -v brew; then
            INFO "Installing Homebrew"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        INFO "Installing brew packages"
        for package in ${BREW_INSTALL_TARGETS[@]}; do
            brew install ${package}
        done
    fi

fi
