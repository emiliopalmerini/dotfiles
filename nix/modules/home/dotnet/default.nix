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
    ];
    # nixpkgs.config.permittedInsecurePackages = [
    #   "dotnet-sdk-6.0.428"
    #   "dotnet-sdk-7.0.410"
    # ];
  };
}
