eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.json)"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init --cmd cd zsh)"
