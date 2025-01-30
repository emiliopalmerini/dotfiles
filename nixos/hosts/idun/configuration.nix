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
        ];
        masApps = {
        };
        onActivation.cleanup = "zap";
      };

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
