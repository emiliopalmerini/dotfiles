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

  # Homer dashboard
  services.homer = {
    enable = true;
    virtualHost = {
      nginx.enable = true;
      domain = "hera";
    };
    settings = {
      title = "Hera";
      subtitle = "Homelab Dashboard";
      header = true;
      footer = "<p>Tailscale-secured homelab</p>";
      columns = 3;
      connectivityCheck = false;
      
      # Quick navigation links
      links = [
        { name = "GitHub"; icon = "fab fa-github"; url = "https://github.com"; }
        { name = "NixOS"; icon = "fab fa-linux"; url = "https://nixos.org"; }
      ];
      
      # Service groups and items
      services = [
        {
          name = "Media & Downloads";
          icon = "fas fa-film";
          items = [
            { 
              name = "Plex"; 
              url = "http://hera:32400/web"; 
              icon = "fas fa-play";
              description = "Media server";
            }
            { 
              name = "qBittorrent"; 
              url = "http://hera:8080"; 
              icon = "fas fa-download";
              description = "Torrent client";
            }
            { 
              name = "Calibre-Web"; 
              url = "http://hera:8083"; 
              icon = "fas fa-book";
              description = "E-book library";
            }
          ];
        }
        {
          name = "Personal Tools";
          icon = "fas fa-tools";
          items = [
            { 
              name = "Spese"; 
              url = "http://hera:8081"; 
              icon = "fas fa-wallet";
              description = "Expense tracker";
            }
            { 
              name = "Peso"; 
              url = "http://hera:8082"; 
              icon = "fas fa-weight";
              description = "Weight tracker";
            }
          ];
        }
        {
          name = "System";
          icon = "fas fa-cogs";
          items = [
            { 
              name = "Homer"; 
              url = "http://hera:8090"; 
              icon = "fas fa-home";
              description = "This dashboard";
            }
          ];
        }
      ];
    };
  };

  # Homer accessible only via Tailscale due to firewall rules
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
