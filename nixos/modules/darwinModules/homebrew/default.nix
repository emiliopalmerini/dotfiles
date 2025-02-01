{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.homebrew;

in {
  options.modules.homebrew = { enable = mkEnableOption "homebrew"; };
  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      brews = [
        "mas"
      ];
      casks = [
        "ghostty"
        "zen-browser"
        "epic-games"
      ];
      masApps = {
      };
      onActivation.cleanup = "zap";
    };

    system.activationScripts.applications.text = let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
      pkgs.lib.mkForce ''
  # Set up applications.
  echo "setting up /Applications..." >&2
  rm -rf /Applications/Nix\ Apps
  mkdir -p /Applications/Nix\ Apps
  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  while read -r src; do
    app_name=$(basename "$src")
    echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  done
      '';
  };
}
