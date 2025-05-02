{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.mainUser;
in
  {
  options.mainUser = {
    enable = mkEnableOption "Enable mainUser module";
    user = mkOption {
      type = types.str;
      default = "emil_io";
      description = "The main user of the system";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
        isNormalUser = true;
        description = "${cfg.user}"; 
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
    };
  };
}
