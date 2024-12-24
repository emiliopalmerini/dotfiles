{ config, pkgs, inputs, ... }:

{
  imports = [
  	./../../modules/homeManagerModules
  ];
  home.username = "emilio";
  home.homeDirectory = "/home/emilio";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  firefox.enable = true;
  neovim.enable = true;
  kitty.enable = true;
  git.enable = true;
  tmux.enable = true;
  zsh.enable = true;

  home.packages = [
    pkgs.gcc
    pkgs.go
    pkgs.lua
  ];

  nixpkgs = {
    overlays = [
      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          own-harpoon-nvim = prev.vimUtils.buildVimPlugin {
            name = "harpoon";
            version = "harpoon2";
            src = inputs.plugin-harpoon;
          };
        };
      })
    ];
  };

  home.file.".config/ohmyposh" = {
    source = ../../../config/ohmyposh;
    recursive = true;
  };

  programs.home-manager.enable = true;
}
