{ lib, config, pkgs, ... }:

{
  options = {
    git = {
      enable = lib.mkEnableOption "enable git";
      userName = lib.mkOption {
        default = "emiliopalmerini";
      };
      userEmail = lib.mkOption {
        default = "emilio.palmerini@proton.me";
      };
    };

  };

    config = lib.mkIf config.git.enable {
    home.packages = [
      pkgs.git-absorb
    ];
    
    programs.git = {
      enable = true;
      userName = config.git.userName;  
      userEmail = config.git.userEmail; 

      extraConfig = {
        core = {
          excludesfile = "./.gitignore_global";
          editor = "nvim";
          autocrlf = "input";
        };
        init.defaultBranch = "main";
        init.templatedir = "./.git_templates";

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
