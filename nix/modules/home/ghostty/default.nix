{ lib, config, ... }:

with lib;
let
  cfg = config.ghostty;
in
{
  options = {
    ghostty.enable = mkEnableOption "Enable Ghostty configuration";
  };

  config = mkIf cfg.enable {
    home.file.".config/ghostty/config".text = ''
      font-family = "Hack Nerd Font Mono"
      font-feature = -calt -liga -dlig
      theme = tokyonight-storm

      # Window/tab management (tmux-like with Ctrl+b prefix)
      keybind = ctrl+b>c=new_tab
      keybind = ctrl+b>"=new_split:down
      keybind = ctrl+b>%=new_split:right

      # Switch tabs (Alt+Shift+H/L like tmux)
      keybind = alt+shift+h=previous_tab
      keybind = alt+shift+l=next_tab

      # Navigate splits (vim-like Ctrl+hjkl)
      keybind = ctrl+h=goto_split:left
      keybind = ctrl+j=goto_split:bottom
      keybind = ctrl+k=goto_split:top
      keybind = ctrl+l=goto_split:right

      # Close split/tab
      keybind = ctrl+b>x=close_surface
    '';
  };
}
