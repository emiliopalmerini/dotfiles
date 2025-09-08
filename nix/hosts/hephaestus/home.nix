{ inputs, pkgs, userConfig, ... }: {
  imports = [
    ./../../modules/home
    inputs.zen-browser.homeModules.twilight
  ];
  # Enable profiles - full workstation configuration
  profiles.base.enable = true;
  profiles.developer.enable = true;
  profiles.developer.enableMongodb = true;
  profiles.desktop.enable = true;
  profiles.work.enable = true;
  
  # Special zen-browser setup for hephaestus
  programs.zen-browser = {
    enable = true;
  };
  
  # Node.js development environment
  nodejs.enable = true;
}
