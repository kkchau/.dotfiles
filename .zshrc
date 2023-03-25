# Homebrew
[[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ASDF
. "$HOME/.asdf/asdf.sh"

# Autocomplte
fpath=(${ASDF_DIR}/completions $fpath)
autoload -U compinit; compinit

# Shared environment
. "$HOME/.environment"

# Prompt
eval "$(starship init zsh)"
