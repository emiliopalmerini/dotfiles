{ userConfig, ...
}: {
  imports = [
    ./../../modules/home
  ];

  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  home.stateVersion = "24.11"; # Please read the comment before changing.

  firefox.enable = true;

  git.enable = true;
  git.userEmail = userConfig.email;
  git.userName = "emiliopalmerini";

  go.enable = true;

  lazygit.enable = true;
  make.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
