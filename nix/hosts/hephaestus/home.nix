{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./../../modules/home
    inputs.zen-browser.homeModules.twilight
  ];
  home = {
    username = "emilio";
    homeDirectory = "/home/emilio";

    stateVersion = "24.11";
  };

  programs.zen-browser = {
    enable = true;
  };
  
  audacity.enable = true;
  bruno.enable = true;
  chrome.enable = true;
  codex.enable = true;
  cursor.enable = false;
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
  obsidian.enable = true;
  office.enable = true;
  postman.enable = true;
  shell.enable = true;
  slack.enable = true;
  telegram.enable = true;
  tmux.enable = true;
  vscode.enable = true;

  home.packages = with pkgs; [
    nodejs
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
