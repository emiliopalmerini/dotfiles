{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.dotnet;
in
{
  options.dotnet = {
    enable = mkEnableOption "Enable dotnet module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotnetCorePackages.sdk_9_0
      dotnetCorePackages.sdk_8_0
    ];
  };
}
