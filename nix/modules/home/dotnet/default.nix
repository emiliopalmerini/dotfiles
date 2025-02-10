{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.dotnet;
  dotnet8 = pkgs.dotnet-sdk.overrideAttrs (old: {
    name = "dotnet-sdk-8.0.404-custom";
  });

  dotnet9 = pkgs.dotnet-sdk.overrideAttrs (old: {
    name = "dotnet-sdk-9.0.101-custom";
  });
in
{
  options.dotnet = {
    enable = mkEnableOption "Enable dotnet module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotnet8
      dotnet9
    ];
  };
}
