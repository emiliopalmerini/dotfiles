{ config, pkgs, ... }: {
  home.username = "emilio";
  home.homeDirectory = "/home/emilio";


  home.sessionVariables = {
    EDITOR = "neovim";
  };

  home.stateVersion = "24.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;
}
