{ lib
, config
, pkgs
, inputs
, ...
}:
with lib; let
  cfg = config.abitudini;
in
{
  options = {
    abitudini = {
      enable = mkEnableOption "Enable abitudini";
      port = mkOption {
        type = types.port;
        default = 8380;
        description = "Port to listen on";
      };
    };
  };
  
  config = mkIf cfg.enable {
    home.packages = [
      inputs.abitudini.packages.${pkgs.stdenv.system}.abitudini
    ];

    systemd.user.services.abitudini = {
      Unit = {
        Description = "Abitudini habit tracker";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${inputs.abitudini.packages.${pkgs.stdenv.system}.abitudini}/bin/abitudini -p ${toString cfg.port}";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}

