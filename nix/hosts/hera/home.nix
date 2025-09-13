{ userConfig, ...
}: {
  imports = [
    ./../../modules/home
  ];

  # Enable profiles - server configuration
  profiles.base.enable = true;
  profiles.developer.enable = true;
  
  # Additional tools
  pdf2md.enable = true;
}
