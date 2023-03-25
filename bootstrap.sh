#!/bin/sh

# Homebrew
if [ "$(uname)" == "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ASDF
if [ -z "$(which asdf)" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.2
fi

# Starship prompt
if [ -z "$(which starship)" ]; then
  curl -fsSL https://starship.rs/install.sh | sh
fi
