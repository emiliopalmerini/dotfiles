{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./../../modules/home
  ];
  home = {
    username = "emilio";
    homeDirectory = "/home/emilio";

    stateVersion = "24.11";
  };

  bruno.enable = true;
  chrome.enable = true;
  dbeaver.enable = false;
  dotnet.enable = true;
  firefox.enable = false;
  gcc.enable = false;
  ghostty.enable = true;
  git = {
    enable = true;
    userEmail = "emilio.palmerini@codiceplastico.com";
    userName = "emiliopalmerini";
  };
  go.enable = true;
  kitty.enable = true;
  lazygit.enable = true;
  make.enable = true;
  mongodb.enable = true;
  neovim.enable = false;
  nvf.enable = true;
  obsidian.enable = true;
  office.enable = true;
  postman.enable = true;
  programs.home-manager.enable = true;
  shell.enable = true;
  slack.enable = true;
  tmux.enable = true;

  home.packages = with pkgs; [
    nodejs_23
  ];

  nixpkgs.config.allowUnfree = true;
}
