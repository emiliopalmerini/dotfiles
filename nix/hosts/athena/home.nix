{
  config,
  pkgs,
  inputs,
  userConfig,
  ...
}: {
  imports = [
    ./../../modules/home
  ];

  # Enable profiles
  profiles.base.enable = true;
  profiles.developer.enable = true;
  profiles.developer.enableMongodb = true;
  profiles.developer.enableDatabase = true;
  profiles.desktop.enable = true;
  profiles.desktop.enableMedia = true;
}
