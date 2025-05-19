{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.tailscale;
in {
  options.tailscale = {
    enable = mkEnableOption "Enable tailscale module";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
