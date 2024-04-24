eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.json)"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

alias ci=zi
alias g=git
alias m=mkdir
alias x=clear
alias zsh='exec zsh'
alias vim=nvim

export POP_SMTP_HOST=smtp.gmail.com
export POP_SMTP_PORT=587
export POP_SMTP_USERNAME=$(pass show env/variables/sftp_email)
export POP_SMTP_PASSWORD=$(pass show env/variables/sftp)
export GOPATH=$HOME/go
export DOTNETPATH=$HOME/dotnet
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$DOTNETPATH/tools

eval "$(zoxide init --cmd cd zsh)"
