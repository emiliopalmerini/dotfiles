plugins=(git)

export POP_SMTP_HOST=smtp.gmail.com
export POP_SMTP_PORT=587
export POP_SMTP_USERNAME=$(pass show macos/env/variables/sftp_email)
export POP_SMTP_PASSWORD=$(pass show macos/env/variables/sftp)
export GOPATH=$HOME/go
export DOTNETPATH=$HOME/dotnet
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$DOTNETPATH/tools

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
