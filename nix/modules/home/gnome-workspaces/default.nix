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
    # Install Spacebar GNOME extension for workspace indicator
    home.packages = with pkgs; [
      gnomeExtensions.spacebar
    ];

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
      # Configure Super+Shift+1 through Super+Shift+6 to move windows to workspaces
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-5 = ["<Super>5"];
        switch-to-workspace-6 = ["<Super>6"];

        move-to-workspace-1 = ["<Super><Shift>1"];
        move-to-workspace-2 = ["<Super><Shift>2"];
        move-to-workspace-3 = ["<Super><Shift>3"];
        move-to-workspace-4 = ["<Super><Shift>4"];
        move-to-workspace-5 = ["<Super><Shift>5"];
        move-to-workspace-6 = ["<Super><Shift>6"];
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
