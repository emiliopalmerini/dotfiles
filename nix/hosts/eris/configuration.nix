{ config, pkgs, inputs, userConfig, commonEnv, ... }:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
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
  system.defaults = {
    dock = {
      autohide = true;
      persistent-apps = [
        "/Applications/Ghostty.app"
        "/Applications/Obsidian.app"
        "/Applications/Zen.app"
        "/Applications/Notion.app"
      ];
    };
    finder =
      {
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true;
        ShowPathbar = true;
      };
    loginwindow.GuestEnabled = false;
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      "com.apple.swipescrolldirection" = true;
      KeyRepeat = 2;
    };
  };

  users.users.${userConfig.username} = {
    home = userConfig.homeDirectory;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    brews = [
    ];
    casks = [
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
    ];
    onActivation.cleanup = "zap";
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
    # useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = { inherit inputs userConfig; };
    backupFileExtension = "backup";
    users = {
      "${userConfig.username}" = import ./home.nix;
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
