{ pkgs, inputs, userConfig, commonEnv, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "thinkpad-home-server";

  # Enable shared modules
  basic-system.enable = true;
  italian-locale.enable = true;
  home-manager-integration.enable = true;
  home-manager-integration.homeConfigPath = ./home.nix;
  media-server.enable = true;
  tailscale-only-access.enable = true;
  tailscale-only-access.allowLocalNetwork = true;
  tailscale-only-access.localNetworkInterface = "enp0s31f6";

  mainUser = {
    enable = true;
    user = userConfig.username;
  };

  # Additional groups specific to thinkpad-home-server
  users.users.${userConfig.username}.extraGroups = [ "plex" ];

  nixpkgs.config.allowUnfree = true;


  environment.variables = commonEnv;

  docker.enable = true;

  # SSH handled by tailscale-only-access module

  # Homer dashboard (replaces Glance)
  services.homer = {
    enable = true;
    # Serve via nginx on hera:8090
    virtualHost = {
      nginx.enable = true;
      domain = "hera";
    };
    settings = {
      title = "Hera";
      subtitle = "Self-hosted services";
      header = true;
      footer = "";
      columns = "auto";
      # Quick links in the top navbar (optional)
      links = [ ];
      # Service groups and items
      services = [
        {
          name = "Strumenti";
          items = [
            { name = "Due Draghi SRD"; url = "http://hera:8000"; }
            { name = "Spese"; url = "http://hera:8081"; }
            { name = "Peso"; url = "http://hera:8082"; }
          ];
        }
        {
          name = "Servizi locali";
          items = [
            { name = "qBittorrent"; url = "http://hera:8080"; }
            { name = "Plex"; url = "http://hera:32400/web"; }
            { name = "Due Draghi SRD Parser"; url = "http://hera:8100"; }
            { name = "Homer"; url = "http://hera:8090"; }
            { name = "Il Turno di Guardia Demo"; url = "http://hera:3001"; }
          ];
        }
      ];
    };
  };

  # Homer will be accessible only via Tailscale due to firewall rules
  services.nginx.virtualHosts."hera".listen = [{ addr = "0.0.0.0"; port = 8090; }];

  environment.systemPackages = with pkgs; [
    nodejs
    (writeScriptBin "pbcopy" ''
      #!/bin/sh
      # OSC 52 escape sequence for clipboard copy
      # Works through SSH with terminals that support OSC 52 (iTerm2, Alacritty, kitty, Ghostty, etc)
      payload=$(base64)
      printf '\033]52;c;%s\007' "$payload"
    '')
    (writeScriptBin "pbpaste" ''
      #!/bin/sh
      # OSC 52 escape sequence for clipboard paste
      # Supported by modern terminals: Ghostty, Alacritty, kitty, and others
      printf '\033]52;c;?\007'
    '')
  ];
  # Tailscale handled by tailscale-only-access module

  # ClamAV
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  programs.zsh.enable = true;

  # logind
  services.logind.settings.Login = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  # Disable display server for SSH-only server
  services.xserver.enable = false;
  services.displayManager.enable = false;

  system.stateVersion = "24.11";
}
