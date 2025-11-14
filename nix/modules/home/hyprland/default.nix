{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland = {
    enable = mkEnableOption "Enable Hyprland configuration with Waybar, Wofi, Dunst, and Swaylock";
  };

  config = mkIf cfg.enable {
    # Install Hyprland-related packages
    home.packages = with pkgs; [
      # App launcher
      wofi

      # Notification daemon
      dunst

      # Screen locker
      swaylock-effects

      # Screenshot tools
      grim
      slurp

      # Clipboard
      wl-clipboard

      # Network management GUI
      networkmanagerapplet
    ];

    # Hyprland configuration
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Monitor configuration
        monitor = ",preferred,auto,1";

        # Execute at launch
        exec-once = [
          "waybar"
          "dunst"
          "nm-applet"
        ];

        # Environment variables
        env = [
          "XCURSOR_SIZE,24"
          "QT_QPA_PLATFORM,wayland"
          "QT_QPA_PLATFORMTHEME,qt5ct"
        ];

        # Input configuration
        input = {
          kb_layout = "us";
          kb_variant = "intl";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
          sensitivity = 0;
        };

        # General window settings
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
        };

        # Decoration settings
        decoration = {
          rounding = 8;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        # Animations
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        # Dwindle layout
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # Master layout
        master = {
          new_status = "master";
        };

        # Gestures
        gestures = {
          workspace_swipe = true;
        };

        # Keybindings
        "$mod" = "SUPER";

        bind = [
          # Application shortcuts
          "$mod, Return, exec, ghostty"
          "$mod, Q, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, nautilus"
          "$mod, V, togglefloating,"
          "$mod, Space, exec, wofi --show drun"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
          "$mod, F, fullscreen,"
          "$mod, L, exec, swaylock"

          # Move focus with SUPER + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Move focus with SUPER + vim keys
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # Switch workspaces with SUPER + [1-6]
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"

          # Move active window to workspace with SUPER + SHIFT + [1-6]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"

          # Scroll through existing workspaces
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # Screenshot
          ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
          "SHIFT, Print, exec, grim - | wl-copy"
        ];

        # Mouse bindings
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        # Workspace rules
        workspace = [
          "1, persistent:true"
          "2, persistent:true"
          "3, persistent:true"
          "4, persistent:true"
          "5, persistent:true"
          "6, persistent:true"
        ];
      };
    };

    # Waybar configuration
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          spacing = 4;

          modules-left = [ "hyprland/workspaces" "hyprland/window" ];
          modules-center = [ "clock" ];
          modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

          "hyprland/workspaces" = {
            format = "{name}";
            on-click = "activate";
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
              "6" = [];
            };
          };

          "hyprland/window" = {
            max-length = 50;
          };

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          cpu = {
            format = " {usage}%";
            tooltip = false;
          };

          memory = {
            format = " {}%";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-icons = [ "" "" "" "" "" ];
          };

          network = {
            format-wifi = " {essid}";
            format-ethernet = " {ipaddr}";
            format-disconnected = "⚠ Disconnected";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = " Muted";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };

          tray = {
            spacing = 10;
          };
        };
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
          border: none;
          border-radius: 0;
        }

        window#waybar {
          background-color: rgba(26, 27, 38, 0.9);
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
        }

        #workspaces button {
          padding: 0 8px;
          background-color: transparent;
          color: #ffffff;
          border-bottom: 3px solid transparent;
        }

        #workspaces button.active {
          background-color: rgba(255, 255, 255, 0.1);
          border-bottom: 3px solid #33ccff;
        }

        #workspaces button.urgent {
          background-color: #eb4d4b;
        }

        #workspaces button:hover {
          background-color: rgba(255, 255, 255, 0.05);
        }

        #window,
        #clock,
        #battery,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #tray {
          padding: 0 10px;
          margin: 0 2px;
        }

        #battery.charging, #battery.plugged {
          color: #26A65B;
        }

        #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        @keyframes blink {
          to {
            background-color: #ffffff;
            color: #000000;
          }
        }

        #pulseaudio.muted {
          color: #888888;
        }
      '';
    };

    # Dunst (notification daemon) configuration
    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          width = 300;
          height = 300;
          origin = "top-right";
          offset = "10x50";
          scale = 0;
          notification_limit = 5;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          indicate_hidden = "yes";
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 0;
          frame_width = 2;
          frame_color = "#33ccff";
          gap_size = 0;
          separator_color = "frame";
          sort = "yes";
          font = "JetBrainsMono Nerd Font 10";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";
          icon_position = "left";
          min_icon_size = 32;
          max_icon_size = 64;
          sticky_history = "yes";
          history_length = 20;
          browser = "zen-browser";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = 8;
          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };

        urgency_low = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          timeout = 10;
        };

        urgency_normal = {
          background = "#1a1b26";
          foreground = "#c0caf5";
          timeout = 10;
        };

        urgency_critical = {
          background = "#f7768e";
          foreground = "#1a1b26";
          frame_color = "#f7768e";
          timeout = 0;
        };
      };
    };

    # Swaylock configuration
    programs.swaylock = {
      enable = true;
      settings = {
        color = "1a1b26";
        font-size = 24;
        indicator-idle-visible = false;
        indicator-radius = 100;
        indicator-thickness = 7;
        inside-color = "1a1b26";
        inside-clear-color = "7aa2f7";
        inside-ver-color = "9ece6a";
        inside-wrong-color = "f7768e";
        key-hl-color = "9ece6a";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-color = "414868";
        ring-clear-color = "7aa2f7";
        ring-ver-color = "9ece6a";
        ring-wrong-color = "f7768e";
        separator-color = "00000000";
        text-color = "c0caf5";
        text-clear-color = "1a1b26";
        text-ver-color = "1a1b26";
        text-wrong-color = "1a1b26";
        show-failed-attempts = true;
      };
    };

    # Wofi configuration
    programs.wofi = {
      enable = true;
      settings = {
        width = 600;
        height = 400;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 40;
        gtk_dark = true;
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 14px;
        }

        window {
          margin: 0px;
          border: 2px solid #33ccff;
          background-color: #1a1b26;
          border-radius: 8px;
        }

        #input {
          margin: 5px;
          border: none;
          color: #c0caf5;
          background-color: #24283b;
          border-radius: 4px;
          padding: 8px;
        }

        #inner-box {
          margin: 5px;
          border: none;
          background-color: #1a1b26;
        }

        #outer-box {
          margin: 5px;
          border: none;
          background-color: #1a1b26;
        }

        #scroll {
          margin: 0px;
          border: none;
        }

        #text {
          margin: 5px;
          border: none;
          color: #c0caf5;
        }

        #entry:selected {
          background-color: #33ccff;
          color: #1a1b26;
          border-radius: 4px;
        }
      '';
    };
  };
}
