{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.gnome-workspaces;
in
{
  options.gnome-workspaces = {
    enable = mkEnableOption "Enable GNOME workspace configuration with 6 workspaces and auto-start applications";
  };

  config = mkIf cfg.enable {
    # GNOME dconf settings for workspaces and keybindings
    dconf.settings = {
      # Set number of static workspaces to 6
      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 6;
        workspaces-only-on-primary = false; # Allow workspaces on all monitors
      };

      # Disable dynamic workspaces (use static instead) and enable auto-maximize
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
        auto-maximize = true;
        workspaces-only-on-primary = false; # Workspaces span all monitors
      };

      # Configure Super+1 through Super+6 keybindings for workspace switching
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-5 = ["<Super>5"];
        switch-to-workspace-6 = ["<Super>6"];
      };

      # Disable default Super+number keybindings for switching to applications
      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
        switch-to-application-6 = [];
        switch-to-application-7 = [];
        switch-to-application-8 = [];
        switch-to-application-9 = [];
      };

    };
  };
}
