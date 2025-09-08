{ inputs
, pkgs
, ...
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

  chrome.enable = true;
  claude.enable = true;
  dotnet.enable = true;
  ghostty.enable = true;
  git = {
    enable = true;
    userEmail = "emilio.palmerini@codiceplastico.com";
    userName = "emiliopalmerini";
  };
  go.enable = true;
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

  home.packages = with pkgs; [
    nodejs
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
