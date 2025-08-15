# Homebrew
[[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Autocomplte
fpath=(${ASDF_DIR}/completions $fpath)
autoload -U compinit; compinit

# Shared environment
. "$HOME/.environment"
. "$HOME/.local_environment"

. "$HOME/.local_environment"

# Prompt
eval "$(starship init zsh)"

source <(fzf --zsh)
