{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.git;
  # Definizione del percorso comune per i file di configurazione di Git
  gitConfigPath = "~/dev/dotfiles/nix/modules/homeManagerModules/git";
in
{
  options = {
    git = {
      enable = mkEnableOption "Enable Git";
      userName = mkOption {
        default = "emiliopalmerini";
        description = "Git user name";
      };
      userEmail = mkOption {
        default = "emilio.palmerini@proton.me";
        description = "Git user email";
      };
    };
  };
  # Configurazione di Git
  config = mkIf cfg.enable { 
    home.packages = [
      pkgs.git-absorb  # Aggiungi il pacchetto git-absorb
    ];

    programs.git = {
      enable = true;
      userName = cfg.userName;  
      userEmail = cfg.userEmail; 

      extraConfig = {
        core = {
          excludesfile = "${gitConfigPath}/.gitignore_global";  # Percorso per .gitignore_global
          editor = "nvim";
          autocrlf = "input";
        };
        init.defaultBranch = "main";
        init.templatedir = "${gitConfigPath}/git_templates";  # Percorso per i template

        filter."lfs" = {
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
        };

        alias = {
          cm = "commit";
          co = "checkout";
          br = "branch";
          ph = "push";
          phf = "push --force";
          pl = "pull";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          gh = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          st = "status";
          sh = "stash";
        };

        pull.rebase = true;
        rerere.enabled = true;
        fetch.prune = true;
      };
    };
  };
}
