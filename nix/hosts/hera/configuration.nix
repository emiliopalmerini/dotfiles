{ pkgs, inputs, userConfig, commonEnv, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "hera";

  # Enable shared modules
  basic-system.enable = true;
  italian-locale.enable = true;
  home-manager-integration.enable = true;
  media-server.enable = true;
  tailscale-only-access.enable = true;

  mainUser = {
    enable = true;
    user = userConfig.username;
  };
  
  # Additional groups specific to hera
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
            { name = "Calibre-Web"; url = "http://hera:8083"; }
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

  environment.systemPackages = with pkgs; [ nodejs calibre ];
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

  # ACPI daemon
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      export PATH=$PATH:/run/current-system/sw/bin
      lid_state=$(awk '{print $NF}' /proc/acpi/button/lid/LID0/state)
      if [ "$lid_state" = "closed" ]; then
        echo 0  > /sys/class/backlight/acpi_video0/brightness
      else
        echo 50 > /sys/class/backlight/acpi_video0/brightness
      fi
    '';
    powerEventCommands = ''
      systemctl suspend
    '';
  };

  system.stateVersion = "24.11";
}
