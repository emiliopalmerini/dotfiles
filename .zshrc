eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.json)"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

source $ZSH/oh-my-zsh.sh
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin

eval "$(zoxide init --cmd cd zsh)"
