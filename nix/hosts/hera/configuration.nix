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
    extraGroups = [ "networkmanager" "wheel" "plex" ];
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

  # Glance dashboard avanzata
  services.glance = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 8090;
        proxied = true; # utile se passi da Traefik/NPM
      };

      # Tema base, modificabile
      theme = {
        background-color = "240 8 9";
        primary-color = "43 50 70";
        text-saturation-multiplier = 1.0;
      };

      pages = [
        {
          name = "Home";
          head-widgets = [
            {
              type = "markets";
              hide-header = true;
              markets = [
                { symbol = "BTC-USD"; name = "Bitcoin"; }
                { symbol = "ETH-USD"; name = "Ethereum"; }
                { symbol = "NVDA"; name = "NVIDIA"; }
                { symbol = "AAPL"; name = "Apple"; }
              ];
            }
          ];
          columns = [
            # Colonna sinistra, info rapide
            {
              size = "small";
              widgets = [
                {
                  type = "split-column";
                  widgets = [
                    { type = "hacker-news"; sort-by = "top"; limit = 15; collapse-after = 5; }
                    { type = "hacker-news"; sort-by = "new"; limit = 10; collapse-after = 5; }
                  ];
                }
                {
                  type = "group";
                  widgets = [
                    {
                      type = "rss";
                      title = "Self-hosting";
                      limit = 12;
                      collapse-after = 6;
                      cache = "6h";
                      feeds = [
                        { url = "https://selfh.st/rss/"; title = "selfh.st"; limit = 4; }
                        { url = "https://news.ycombinator.com/rss"; title = "HN RSS"; limit = 6; }
                        { url = "https://ciechanow.ski/atom.xml"; title = "Ciechanow"; }
                        { url = "https://www.joshwcomeau.com/rss.xml"; title = "Josh Comeau"; }
                      ];
                    }
                  ];
                }
              ];
            }

            # Colonna centrale, feed e HN
            {
              size = "full";
              widgets = [
                { type = "clock"; time-zone = "Europe/Rome"; }
                {
                  type = "weather";
                  location = "Desio, Italy";
                  units = "metric";
                  hour-format = "24h";
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      name = "Servizi locali";
                      links = [
                        { title = "qBittorrent"; url = "http://hera:8080"; }
                        { title = "Calibre-Web"; url = "http://hera:8083"; }
                        { title = "Plex"; url = "http://hera:32400/web"; }
                        { title = "Glance"; url = "http://hera:8090"; }
                        { title = "Due Draghi SRD"; url = "http://hera:8000"; }
                        { title = "Il Turno di Guardia Demo"; url = "http://hera:3001"; }
                        { title = "Dockploy"; url = "http://hera:3000"; }
                      ];
                    }
                  ];
                }
                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
              ];
            }

            # Colonna destra, stato server e siti
            {
              size = "small";
              widgets = [
                # Statistiche del server locale
                {
                  type = "server-stats";
                  servers = [{ type = "local"; name = "Hera"; hide-swap = false; }];
                }

                # Monitor HTTP(s) di servizi pubblici
                {
                  type = "monitor";
                  services = [
                    {
                      name = "Due Draghi al Microfono";
                      url = "https://duedraghialmicrofono.com/";
                      icon = "si:icloud"; # personalizza se vuoi un logo
                    }
                    {
                      name = "Plex Web";
                      url = "http://hera:32400/web";
                      icon = "mdi:filmstrip";
                    }
                    {
                      name = "qBittorrent";
                      url = "http://hera:8080/";
                      icon = "mdi:download";
                    }
                    {
                      name = "Calibre-Web";
                      url = "http://hera:8083/";
                      icon = "mdi:book";
                    }
                  ];
                }
              ];
            }
          ];
        }

        # Pagina secondaria: Media e utilità
        {
          name = "Media";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "bookmarks";
                  groups = [
                    {
                      name = "Podcast / Social";
                      links = [
                        { title = "Due Draghi Sito"; url = "https://duedraghialmicrofono.com/"; }
                        { title = "YouTube Studio"; url = "https://www.youtube.com/duedraghialmicrofono"; }
                        { title = "Patreon"; url = "https://www.patreon.com/DueDraghiPlus"; }
                        { title = "Spotify for Podcasters"; url = "https://podcasters.spotify.com/"; }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };

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
