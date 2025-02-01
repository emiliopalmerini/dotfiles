{ lib, config, pkgs, ... }:

let
  # Definizione delle opzioni per il modulo
  options = {
    dotnet.enable = lib.mkEnableOption "Enable dotnet";
  };
in
{
  # Configurazione del modulo
  config = lib.mkIf config.dotnet.enable {
    home.packages = [
      pkgs.dotnetCorePackages.sdk_9_0
      pkgs.dotnetCorePackages.sdk_8_0
    ];
  };
}

