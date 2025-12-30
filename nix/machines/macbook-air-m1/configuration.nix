{ config, pkgs, inputs, userConfig, commonEnv, ... }:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../modules/darwin
  ];
  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  system.stateVersion = 5;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.variables = commonEnv // {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
  system.primaryUser = userConfig.username;

  environment.systemPackages = [ ];

  # Darwin module configurations
  darwin.dock = {
    enable = true;
    autohide = true;
    persistentApps = [
      "/Applications/Ghostty.app"
      "/Applications/Cursor.app"
      "/Applications/Obsidian.app"
      "/Applications/Zen.app"
      "/Applications/Notion.app"
    ];
  };

  darwin.systemDefaults = {
    enable = true;
    finder = {
      preferredViewStyle = "clmv";
      removeOldTrashItems = true;
      showPathbar = true;
    };
    loginwindow.guestEnabled = false;
    globalDomain = {
      force24HourTime = true;
      interfaceStyle = "Dark";
      naturalScrollDirection = true;
      keyRepeat = 2;
      hideMenuBar = true;
    };
  };

  users.users.${userConfig.username} = {
    home = userConfig.homeDirectory;
    shell = pkgs.zsh;
  };

  darwin.applications.enable = true;

  darwin.homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      # Fonts
      "font-hack-nerd-font"

      # Terminal & Development
      "ghostty"

      # Database & Data Tools
      "mongodb-compass"

      # Media & Content Creation
      "obs"
      "vlc"

      # Productivity & Notes
      "obsidian"
      "notion"
      "notion-calendar"

      # Communication
      "legcord"

      # Browsers
      "zen"

      # IDEs and editors
      "cursor"

      # System Utilities
      "rectangle"           # Window management
      "caffeine"            # Keep Mac awake
      "logi-options+"       # Logitech device management

      # Smart Home
      "home-assistant"
    ];
    cleanup = "zap";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs userConfig; };
    backupFileExtension = "backup";
    users = {
      "${userConfig.username}" = import ./home.nix;
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
