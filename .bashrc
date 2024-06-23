if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/ohmyposh.toml)"
fi

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias ci=zi
alias g=git
alias m=mkdir
alias bash='exec bash'
alias tkui=taskwarrior-tui
alias tk=task
alias tksave='git commit . --m "backup"; git pull; git push'
alias cat=bat
alias dkc='docker-compose'
alias cdw='cd /mnt/c/Users/emili/'
alias compose=docker-compose

# Bat (better cat)
export BAT_THEME=tokyonight_night

export GOPATH=$HOME/go
export DOTNETPATH=$HOME/dotnet
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$DOTNETPATH/tools
