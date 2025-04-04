{ pkgs, ... }:
let
  zshShell = "${pkgs.zsh}/bin/zsh";
in
{
  imports = [
    ./../../modules/home
  ];

  home.username = "prometeo";
  home.homeDirectory = "/home/prometeo";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  git.enable = true;
  git.userEmail = "emilio.palmerini@condiceplastico.com";
  git.userName = "emiliopalmerini";

  go.enable = true;
  gcc.enable = true;
  lazygit.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  make.enable = true;

  nixpkgs.config.allowUnfree = true;

  home = {
    activation = {
      addZshToShells = ''
        if ! grep -q '${zshShell}' /etc/shells; then
          echo '${zshShell}' | /usr/bin/sudo tee -a /etc/shells > /dev/null
        fi
      '';
    };
  };

  programs.home-manager.enable = true;
}
