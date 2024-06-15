{ config, pkgs, ... }:
{
  enable = true;
  lfs.enable = true;
  userName = "Emilio";
  userEmail = "emilio.palmerini@proton.me";
  signing.key = null;
  signing.signByDefault = true;

  extraConfig = {
    pull = {
      rebase = true;
    };
    init = {
      defaultBranch = "main";
    };
  };
}
