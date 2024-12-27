{ lib, config, pkgs, ... }:
{
  options.dotnet.enable = lib.mkEnableOption "Enable .NET Core environment";

  config = lib.mkIf config.dotnet.enable {
    environment.systemPackages = [
      pkgs.dotnetCorePackages.sdk_9_0
      pkgs.dotnetCorePackages.sdk_8_0
    ];
  };
}

