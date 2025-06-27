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
  
  audacity.enable = true;
  bruno.enable = true;
  codex.enable = true;
  chrome.enable = true;
  dbeaver.enable = false;
  dotnet.enable = true;
  discord.enable = true;
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
  neovim.enable = true;
  nvf.enable = false;
  obsidian.enable = true;
  office.enable = true;
  postman.enable = true;
  shell.enable = true;
  slack.enable = true;
  telegram.enable = true;
  tmux.enable = true;
  vscode.enable = true;

  home.packages = with pkgs; [
    filezilla
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
