{ lib, config, pkgs, ... }:

let
  cfg = config.customShell;
  myAliases = {
    cd = "z";
    c = "clear";
    g = "git";
    m = "mkdir";
    ls = "ls --color";
    cat = "bat";
    switch = "sudo nixos-rebuild switch --flake";
    test = "sudo nixos-rebuild test --flake";
  };
  oh-my-posh-config = ./oh-my-posh.json;
  zshColors = "\${(s.:.)LS_COLORS}";
in
{
  options.customShell = {
    enable = lib.mkEnableOption "enable zsh module";
  };

  config = lib.mkIf cfg.enable {
    programs.bat.enable = true;
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;

      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile oh-my-posh-config)); 
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = myAliases ;

      initExtra = '' 
        if [[ -f "/opt/homebrew/bin/brew" ]] then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        HISTDUP=erase
        
        setopt HIST_FIND_NO_DUPS
        setopt HIST_IGNORE_SPACE
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_IGNORE_DUPS
        setopt NO_BEEP

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':completion:*' list-colors "${zshColors}"
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath' 

        bindkey -e
        bindkey '^Y' yank
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        eval "$(oh-my-posh init zsh)"
        '';
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "v1.1.2";
            sha256 = "Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
          };
        }
      ];
    };
  };
}
