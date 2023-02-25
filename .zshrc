. "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
autoload -U compinit; compinit
. "$HOME/.environment"
eval "$(starship init zsh)"
