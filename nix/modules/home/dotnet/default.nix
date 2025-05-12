{
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotnet.enable = lib.mkEnableOption "Enable .NET SDKS";

  config = lib.mkIf config.dotnet.enable {
    home.packages = with pkgs; [
      dotnet-sdk_9
      dotnetPackages.Nuget
      netcoredbg
    ];
  };
}
