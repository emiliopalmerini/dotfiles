{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 5;


  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
    environment.variables = {
      EDITOR = "nvim";
      TERM = "xterm-256color";
    };
    system.defaults = {
      dock.autohide  = true;
      dock.persistent-apps = [
        "${pkgs.obsidian}/Applications/Obsidian.app"
        "${pkgs.kitty}/Applications/kitty.app"
        "/Applications/Zen Browser.app"
      ];
      finder.FXPreferredViewStyle = "clmv";
      loginwindow.GuestEnabled  = false;
      NSGlobalDomain.AppleICUForce24HourTime = true;
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain."com.apple.swipescrolldirection" = true;
    };


  users.users.emiliopalmerini = {
    home = /Users/emiliopalmerini;
    shell = pkgs.zsh;
  };

    homebrew = {
      enable = true;
      brews = [
        "mas"
        "docker-compose"
        "clamav"
      ];
      casks = [
        "zen-browser"
        "epic-games"
        "obs"
        "logi-options+"
        "docker"
        "vlc"
      ];
      masApps = {
      "CapCut" = 1500855883;
      "HomeAssistant" = 1099568401;
      };
      onActivation.cleanup = "zap";
    };

    system.activationScripts.applications.text = let
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
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "backup";
    users = {
      "emiliopalmerini" = import ./home.nix;
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
