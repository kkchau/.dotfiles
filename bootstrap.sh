#!/bin/sh

# ASDF
if [ -z "$(which asdf)" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.2
fi

# Starship prompt
if [ -z "$(which starship)" ]; then
  curl -fsSL https://starship.rs/install.sh | sh
fi
