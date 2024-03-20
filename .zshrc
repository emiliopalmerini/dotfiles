eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.json)"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

source $ZSH/oh-my-zsh.sh

## Shell integration
export ITERM2_SQUELCH_MARK=1
source ~/.iterm2_shell_integration.zsh
eval "$(zoxide init --cmd cd zsh)"
