plugins=(git)

export POP_SMTP_HOST=smtp.gmail.com
export POP_SMTP_PORT=587
export POP_SMTP_USERNAME=$(pass show macos/env/variables/sftp_email)
export POP_SMTP_PASSWORD=$(pass show macos/env/variables/sftp)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
