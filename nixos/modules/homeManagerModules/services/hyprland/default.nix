{ pkgs, lib, config, inputs, ... }: 
  let
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
  
      sleep 1
  
      ${pkgs.swww}/bin/swww img ${./wallpaper.png} &
    '';
in
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    wayland.windowManager.hyprland = {
      enable = true;

      xwayland.enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;

      plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
        borders-plus-plus
      ];

      settings = {
        "$mod" = "SUPER";
        bind =
          [
            "$mod, F, exec, firefox"
            ", Print, exec, grimblast copy area"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
              9)
          );
        "plugin:borders-plus-plus" = {
          add_borders = 1;

          "col.border_1" = "rgb(ffffff)";
          "col.border_2" = "rgb(2222ff)";

          border_size_1 = 10;
          border_size_2 = -1;

          natural_rounding = "yes";
        };

        exec-once = ''${startupScript}/bin/start'';
      };
    };
  };
}
