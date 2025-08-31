{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hera";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };
  console.keyMap = "us-acentos";

  users.users.prometeo = {
    isNormalUser = true;
    description = "Prometeo";
    extraGroups = [ "networkmanager" "wheel" "plex" "docker" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.prometeo = import ./home.nix;
    backupFileExtension = "bak";
  };

  environment.variables = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
  };

  docker.enable = true;

  # qBittorrent
  services.qbittorrent = {
    enable = true;
    profileDir = "/var/lib/qbittorrent";
    openFirewall = true; # apre webuiPort e torrentingPort
    webuiPort = 8080; # --webui-port
    torrentingPort = 6881; # --torrenting-port
    serverConfig = {
      Preferences = {
        Downloads = {
          SavePath = "/var/lib/plex/movies/";
        };
        WebUI = {
          Address = "0.0.0.0"; # bind su tutte le interfacce
        };
      };
      Categories = {
        movies = { SavePath = "/var/lib/plex/movies/"; SavePathEnabled = true; };
        tv = { SavePath = "/var/lib/plex/tv/"; SavePathEnabled = true; };
        music = { SavePath = "/var/lib/plex/music/"; SavePathEnabled = true; };
      };
      LegalNotice = { Accepted = true; };
    };
  };

  # UMask e gruppo plex per scrivere nelle librerie Plex
  systemd.services.qbittorrent.serviceConfig.UMask = "0002";
  users.users.qbittorrent.extraGroups = [ "plex" ];

  # Calibre-Web
  services.calibre-web = {
    enable = true;
    dataDir = "/var/lib/calibre-web";
    listen = { ip = "0.0.0.0"; port = 8083; };
    openFirewall = true;
  };


  # Calibre completo (desktop/CLI + calibre-server)
  systemd.services.calibre-server = {
    description = "Calibre Content Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.calibre}/bin/calibre-server /var/lib/calibre-web/library --port 8084 --with-library";
      User = "calibre-web";
      Group = "calibre-web";
      Restart = "always";
    };
  };

  # Directory e permessi
  systemd.tmpfiles.rules = [
    "d /var/lib/calibre-web/library 0755 calibre-web calibre-web -"
    # qBittorrent stato/config
    "d /var/lib/qbittorrent 0755 qbittorrent qbittorrent -"
    # Calibre-Web stato e libreria
    "d /var/lib/calibre-web 0755 calibre-web calibre-web -"
    "d /var/lib/calibre-web/config 0755 calibre-web calibre-web -"
    "d /var/lib/calibre-web/library 0755 calibre-web calibre-web -"
    # Plex librerie (setgid per mantenere il gruppo)
    "d /var/lib/plex 2775 root plex -"
    "d /var/lib/plex/tv 2775 root plex -"
    "d /var/lib/plex/movies 2775 root plex -"
    "d /var/lib/plex/music 2775 root plex -"
  ];

  services.openssh.enable = true;

  # Plex
  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "plex";
    group = "plex";
  };

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
            { name = "Registra spese"; url = "http://hera:8081"; }
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

  # Bind Homer vhost on all interfaces at port 8090
  services.nginx.virtualHosts."hera".listen = [{ addr = "0.0.0.0"; port = 8090; }];

  environment.systemPackages = with pkgs; [ nodejs calibre ];
  # Tailscale
  services.tailscale.enable = true;

  # ClamAV
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  programs.zsh.enable = true;

  # logind
  services.logind = {
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
