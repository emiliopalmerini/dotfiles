{ lib, config, pkgs, ... }: 
{
  options = {
    alacritty.enable = lib.mkEnableOption "enable alacritty module";
  };

  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        live_config_reload = true;

        bell = {
          animation = "EaseOutExpo";
          duration = 0;
        };

        colors = {
          draw_bold_text_with_bright_colors = true;

          indexed_colors = [
            { color = "0xF8BD96"; index = 16; }
            { color = "0xF5E0DC"; index = 17; }
          ];

          bright = {
            black = "0x988BA2";
            blue = "0x96CDFB";
            cyan = "0x89DCEB";
            green = "0xABE9B3";
            magenta = "0xF5C2E7";
            red = "0xF28FAD";
            white = "0xD9E0EE";
            yellow = "0xFAE3B0";
          };

          cursor = {
            cursor = "0xF5E0DC";
            text = "0x1E1D2F";
          };

          normal = {
            black = "0x6E6C7E";
            blue = "0x96CDFB";
            cyan = "0x89DCEB";
            green = "0xABE9B3";
            magenta = "0xF5C2E7";
            red = "0xF28FAD";
            white = "0xD9E0EE";
            yellow = "0xFAE3B0";
          };

          primary = {
            background = "0x1E1D2F";
            foreground = "0xD9E0EE";
          };
        };

        cursor = {
          blink_interval = 500;
          blink_timeout = 5;
          unfocused_hollow = false;

          style = {
            blinking = "Off";
            shape = "Block";
          };
        };

        env = {
          TERM = "xterm-256color";
        };

        font = {
          size = 18;

          glyph_offset = {
            x = 0;
            y = 0;
          };

          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };

          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };

          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };

          offset = {
            x = 0;
            y = 0;
          };
        };

        mouse = {
          hide_when_typing = true;

          bindings = [
            {
              action = "PasteSelection";
              mouse = "Middle";
            }
          ];
        };

        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>";
        };

        shell = {
          program = "/bin/zsh";
        };

        window = {
          decorations = "full";
          dynamic_title = true;
          startup_mode = "Maximized";

          dimensions = {
            columns = 160;
            lines = 80;
          };

          padding = {
            x = 4;
            y = 4;
          };
        };
      };
    };

  };
}
