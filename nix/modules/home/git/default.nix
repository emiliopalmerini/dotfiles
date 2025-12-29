{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.git;
  configDir = builtins.toString ./config;
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
          excludesfile = "${configDir}/.gitignore_global";
          editor = "nvim";
          autocrlf = "input";
          hooksPath = "${configDir}/hooks";
        };
        init.defaultBranch = "main";

        filter."lfs" = {
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
        };

        alias = {
          a = "add";
          br = "branch";
          cm = "commit";
          co = "checkout";
          cp = "cherry-pick";
          d = "diff";
          graph = "log --oneline --all --graph";
          last = "log -1 HEAD";
          ph = "push";
          phf = "push --force-with-lease";
          pl = "pull";
          sh = "stash";
          st = "status";
          t = "tag";
          unstage = "reset HEAD --";
        };

        diff.algorithm = "histogram";
        merge.conflictstyle = "zdiff3";
        pull.rebase = true;
        rerere.enabled = true;
        fetch.prune = true;
      };
    };
  };
}
