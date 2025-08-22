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

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        environment = {
          PUID = "1000";
          PGID = "193";
          TZ = "Europe/Rome";
          WEBUI_PORT = "8080";
        };
        ports = [
          "8080:8080"
          "6881:6881"
          "6881:6881/udp"
        ];
        volumes = [
          "/var/lib/qbittorrent/config:/config"
          "/var/lib/plex/tv:/downloads/tv"
          "/var/lib/plex/movies:/downloads/movies"
          "/var/lib/plex/music:/downloads/music"
        ];
        extraOptions = [
          "--label=glance.enabled=true"
          "--label=glance.name=qBittorrent"
          "--label=glance.description=Torrent Client"
          "--label=glance.url=http://hera:8080"
          "--label=glance.category=Downloads"
          "--restart=unless-stopped"
        ];
      };

      calibre-web = {
        image = "lscr.io/linuxserver/calibre-web:latest";
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "Europe/Rome";
          DOCKER_MODS = "linuxserver/mods:universal-calibre";
        };
        ports = [ "8083:8083" ];
        volumes = [
          "/var/lib/calibre-web/config:/config"
          "/var/lib/calibre-web/library:/books"
        ];
        extraOptions = [
          "--label=glance.enabled=true"
          "--label=glance.name=Calibre-Web"
          "--label=glance.description=Web Ebook Library"
          "--label=glance.url=http://hera:8083"
          "--label=glance.category=Media"
          "--restart=unless-stopped"
        ];
      };

      glance = {
        image = "glanceapp/glance";
        environment = {
          MY_SECRET_TOKEN = "123456";
        };
        ports = [ "7042:8080" ];
        volumes = [
          "/var/lib/glance/config:/app/config"
          "/var/lib/glance/assets:/app/assets"
          "/run/docker.sock:/var/run/docker.sock:ro"
        ];
        extraOptions = [
          "--label=glance.enabled=true"
          "--label=glance.name=Glance"
          "--label=glance.description=Dashboard"
          "--label=glance.url=http://hera:7042"
          "--label=glance.category=Utility"
          "--restart=unless-stopped"
        ];
      };
    };
  };

  # Ensure bind-mount paths exist
  systemd.tmpfiles.rules = [
    "d /var/lib/qbittorrent 0755 root root -"
    "d /var/lib/qbittorrent/config 0755 root root -"
    "d /var/lib/calibre-web 0755 root root -"
    "d /var/lib/calibre-web/config 0755 root root -"
    "d /var/lib/calibre-web/library 0755 root root -"
    "d /var/lib/glance 0755 root root -"
    "d /var/lib/glance/config 0755 root root -"
    "d /var/lib/glance/assets 0755 root root -"
    "d /var/lib/plex 0755 root root -"
    "d /var/lib/plex/tv 0755 root root -"
    "d /var/lib/plex/movies 0755 root root -"
    "d /var/lib/plex/music 0755 root root -"
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

  environment.systemPackages = with pkgs; [ nodejs lazydocker docker-compose ];
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
