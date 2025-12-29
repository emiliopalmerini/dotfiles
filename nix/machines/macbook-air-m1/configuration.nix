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
  # services.tailscale.enable = true;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.variables = commonEnv // {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
  system.primaryUser = userConfig.username;

  environment.systemPackages = with pkgs; [
    # Docker requires system-level access on macOS
    docker
    docker-compose
    colima
  ];

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

      # System Utilities
      "rectangle"           # Window management
      "caffeine"            # Keep Mac awake
      "logi-options+"       # Logitech device management

      # Smart Home
      "home-assistant"
    ];
    cleanup = "zap";
  };

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  home-manager = {
    extraSpecialArgs = { inherit inputs userConfig; };
    backupFileExtension = "backup";
    users = {
      "${userConfig.username}" = import ./home.nix;
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
