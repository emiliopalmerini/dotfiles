{ userConfig, pkgs, lib, ... }:
{
  imports = [
    ./../../modules/home
  ];

  # Base Home Manager configuration
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Git configuration
  git.enable = true;
  git.userEmail = userConfig.email;
  git.userName = "emiliopalmerini";

  # Core developer tools for server management (complex modules)
  go.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;

  # Simple packages - installed directly
  home.packages = [
    pkgs.claude-code
    pkgs.lazygit
    pkgs.gnumake
  ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.xclip ];
}
