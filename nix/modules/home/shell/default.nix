{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.shell;
  myAliases = {
    cd = "z";
    c = "clear";
    g = "git";
    m = "mkdir";
    ls = "ls --color";
    cat = "bat";

    # NixOS commands
    nixos-switch = "sudo nixos-rebuild switch --flake";
    nixos-test = "sudo nixos-rebuild test --flake";
    nixos-upgrade = "sudo nixos-rebuild switch --upgrade --flake";
    darwin-switch = "sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dev/dotfiles/nix#eris --show-trace";

    # Git commands
    ga = "git add .";
    gco = "git commit";
    gph = "git push";
    gphf = "git push --force";
    gpl = "git pull";
    gst = "git status";
    gch = "git checkout";
    gcb = "git checkout -b";
    gl = "git log --oneline --graph --decorate --all";
    gd = "git diff"; # Mostra le modifiche
    gds = "git diff --staged"; # Mostra le modifiche già aggiunte
    gr = "git reset"; # Reset generico
    grs = "git reset --soft HEAD~1"; # Reset soft dell'ultimo commit
    grh = "git reset --hard HEAD~1"; # Reset hard dell'ultimo commit
    gbr = "git branch"; # Mostra i branch locali
    gbD = "git branch -D"; # Cancella un branch locale
    gfp = "git fetch --prune"; # Pulisce i branch remoti eliminati
    gmt = "git mergetool"; # Avvia il tool di merge
    gsta = "git stash"; # Salva modifiche non committate
    gstp = "git stash pop"; # Recupera l'ultimo stash
    gstd = "git stash drop"; # Elimina l'ultimo stash
    gam = "git commit --amend --no-edit"; # Modifica l'ultimo commit senza cambiare il messaggio
    gfa = "git fetch --all"; # Fetch di tutti i branch remoti
    grhh = "git reset --hard"; # Reset hard all'ultimo commit
  };
  oh-my-posh-config = ./oh-my-posh.json;
  zshColors = "\${(s.:.)LS_COLORS}";
in {
  options.shell = {
    enable = mkEnableOption "enable zsh module";
  };

  config = mkIf cfg.enable {
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

      shellAliases = myAliases;

      initContent = ''
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

    home.packages = with pkgs; [
      jq
      jqp
    ];
  };
}
