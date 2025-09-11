{ pkgs, userConfig, ... }:
{
  imports = [
    ./../../modules/home
  ];

  # Enable profiles - macOS configuration
  profiles.base.enable = true;
  profiles.developer.enable = true;
  profiles.desktop.enable = true;
  profiles.desktop.enableCommunication = true;
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
    rectangle
  ];

  # Additional tools
  bruno.enable = true;
  discord.enable = false;
  gimp.enable = true;
  lua.enable = true;
  nodejs.enable = true;
  hugo.enable = false; # Disabled since we have it in packages
}

