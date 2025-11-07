{ config, pkgs, inputs, userConfig, commonEnv, ... }:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../modules/darwin
  ];
  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 5;
  services.tailscale.enable = true;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.variables = commonEnv // {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
  system.primaryUser = userConfig.username;
  # Darwin module configurations
  darwin.dock = {
    enable = true;
    autohide = true;
    persistentApps = [
      "/Applications/Ghostty.app"
      "/Applications/Obsidian.app"
      "/Applications/Zen Browser.app"
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
      "arc"
      "ghostty"
      "mongodb-compass"
      "obs"
      "obsidian"
      "logi-options+"
      "legcord"
      "notion"
      "vlc"
      "home-assistant"
      "rectangle"
      "zen-browser"
    ];
    cleanup = "zap";
  };

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
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
