{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.system;

in {
  options.modules.system = { enable = mkEnableOption "system"; };
  config = mkIf cfg.enable {
    environment.variables = {
      EDITOR = "nvim";
      TERM = "xterm-256color";
    };
    system.defaults = {
      dock.autohide  = true;
      dock.persistent-apps = [
        "${pkgs.obsidian}/Applications/Obsidian.app"
        "/Applications/Ghostty.app"
        "/Applications/Zen Browser.app"
      ];
      finder.FXPreferredViewStyle = "clmv";
      loginwindow.GuestEnabled  = false;
      NSGlobalDomain.AppleICUForce24HourTime = true;
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      NSGlobalDomain.KeyRepeat = 2;
    };

  };
}
