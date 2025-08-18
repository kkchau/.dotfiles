#!/bin/sh

source ./util.sh

# macOS
if [ "$(uname)" = "Darwin" ]; then
    [ -z "$(which brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Automatically install mise for macOS.
    # If on Linux system, user should install manually since I'm not going to handle 
    # every incancation of this command.
    [ -z "$(which mise)" ] && curl https://mise.run | sh

    BREW_INSTALL_TARGETS=(
        cmake
        coreutils
        fzf
        ripgrep
        tmux
    )

    INFO "Requesting to install the following brew targets:"
    INFO "${BREW_INSTALL_TARGETS[@]}"
    read -p "Install homebrew and brew packages? [Y/n]: " INSTALL_BREW

    if [[ ${INSTALL_BREW} =~ ${CONFIRM_Y} ]]; then
        if ! command -v brew; then
            WARN "Homebrew is not installed, can't continue."
        else
            INFO "Installing brew packages"
            for package in ${BREW_INSTALL_TARGETS[@]}; do
                brew install ${package}
            done
        fi
    fi
fi

# Starship prompt
if [ -z "$(which starship)" ]; then
  curl -fsSL https://starship.rs/install.sh | sh
fi
