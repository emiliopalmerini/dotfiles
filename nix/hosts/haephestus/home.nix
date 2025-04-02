{ pkgs, ... }:
let
  zshShell = "${pkgs.zsh}/bin/zsh";
in
{
  imports = [
    ./../../modules/home
  ];

  home.packages = with pkgs; [ wl-copy ];

  home.username = "prometeo";
  home.homeDirectory = "/home/prometeo";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  git.enable = true;
  git.userEmail = "emilio.palmerini@condiceplastico.com";
  git.userName = "emiliopalmerini";

  kitty.enable = true;
  go.enable = true;
  gcc.enable = true;
  lazygit.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  make.enable = true;

  home = {
    activation = {
      addZshToShells = ''
        if ! grep -q '${zshShell}' /etc/shells; then
          sudo echo '${zshShell}' >> /etc/shells
        fi
      '';
    };

    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
  };
}
