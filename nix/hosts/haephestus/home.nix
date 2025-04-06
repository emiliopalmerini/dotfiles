{ pkgs, inputs, ... }:
let
  zshShell = "${pkgs.zsh}/bin/zsh";
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.home-manager.darwinModules.default
    ../../modules/home
  ];
  home = {
    username = "prometeo";
    homeDirectory = "/home/prometeo";

    stateVersion = "24.11";

    activation = {
      addZshToShells = ''
        if ! grep -q '${zshShell}' /etc/shells; then
          echo '${zshShell}' | /usr/bin/sudo tee -a /etc/shells > /dev/null
        fi
      '';
    };
  };

  git = {
    enable = true;
    userEmail = "emilio.palmerini@condiceplastico.com";
    userName = "emiliopalmerini";
  };

  nvf.enable = true;
  kitty.enable = true;
  ghostty.enable = true;
  gcc.enable = true;
  go.enable = true;
  lazygit.enable = true;
  shell.enable = true;
  tmux.enable = true;
  make.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
