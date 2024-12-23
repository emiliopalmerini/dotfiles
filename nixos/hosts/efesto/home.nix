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

  home.packages = [
    pkgs.gcc
    pkgs.go
    pkgs.lua
    pkgs.oh-my-posh
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

  home.file.".config/.zshrc" = {
    source = home/emilio/dotfiles/.zshrc;
  };
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/emilio/etc/profile.d/hm-session-vars.sh
  #

  programs.home-manager.enable = true;
}
