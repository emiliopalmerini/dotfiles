eval "$(oh-my-posh init zsh --config ~/.mytheme.omp.json)"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

source $ZSH/oh-my-zsh.sh
export POP_SMTP_HOST=smtp.gmail.com
export POP_SMTP_PORT=587
export POP_SMTP_USERNAME=$(pass show env/variables/sftp_email)
export POP_SMTP_PASSWORD=$(pass show env/variables/sftp)

eval "$(zoxide init --cmd cd zsh)"
