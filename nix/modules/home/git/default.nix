{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.git;
  gitConfigPath = "${config.home.homeDirectory}/repos/dotfiles/nix/modules/home/git/config";
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
        default = "emilio.palmerini@gmail.com";
        description = "Git user email";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.git-absorb
      pkgs.git-lfs
    ];

    programs.git = {
      enable = true;

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
        core = {
          excludesfile = "${gitConfigPath}/.gitignore_global"; # Percorso per .gitignore_global
          editor = "nvim";
          autocrlf = "input";
          hooksPath = "${gitConfigPath}/hooks";
        };
        init.defaultBranch = "main";

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
