{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.virtualBox;
in {
  options.virtualBox = {
    enable = mkEnableOption "Enable virtualBox module";
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;

    users.extraGroups.vboxusers.members = ["emilio"];
  };
}
