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

        diff = {
          algorithm = "histogram";
          colorMoved = "default";
        };
        merge.conflictstyle = "zdiff3";
        pull.rebase = true;
        rerere.enabled = true;
        fetch.prune = true;
      };
    };

    programs.delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        theme = "tokyonight_storm";
      };
    };
  };
}
