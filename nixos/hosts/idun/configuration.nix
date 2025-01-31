{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    alacritty
  ];

  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 5;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;

  users.users.emiliopalmerini = {
    home = /Users/emiliopalmerini;
    shell = pkgs.zsh;
  };
  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "ghostty"
      "zen-browser"
      "epic-games"
    ];
    masApps = {
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


  environment.variables = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
  };
  system.defaults = {
    dock.autohide  = true;
    dock.persistent-apps = [
      "${pkgs.obsidian}/Applications/Obsidian.app"
      "/Applications/Ghostty.app"
      "/Applications/Zen Browser.app"
    ];
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled  = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
