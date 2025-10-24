{ pkgs, ... }:
{
  imports = [
    ./../../modules/home
  ];

  # Enable profiles - macOS configuration
  profiles.base.enable = true;
  profiles.developer.enable = true;
  profiles.desktop.enable = true;
  profiles.desktop.enableCommunication = false; # Telegram not available on macOS via Nix
  profiles.desktop.enableMedia = false; # No VLC needed

  # macOS specific session path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # macOS specific packages and tools
  home.packages = with pkgs; [
    mongosh
    mongodb-tools
    raycast
    docker
    docker-compose
    lazydocker
    mas
    clamav
    hugo
    colima
  ];

  # Additional tools
  bruno.enable = false; # Not available on macOS via Nix
  discord.enable = false;
  gimp.enable = false; # Not available on macOS via Nix
  lua.enable = true;
  nodejs.enable = true;
  hugo.enable = false; # Disabled since we have it in packages
}

