{ lib
, config
, pkgs
, ...
}:
with lib; let
  cfg = config.tmux;
in
{
  options = {
    tmux.enable = mkEnableOption "enable tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on
        set -sg escape-time 0
        set -g history-limit 50000

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-option -g renumber-windows on

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # vi-mode for copy
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Splits and new windows preserve current directory
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';

      plugins = [
        pkgs.tmuxPlugins.yank
        pkgs.tmuxPlugins.vim-tmux-navigator
        pkgs.tmuxPlugins.tokyo-night-tmux
      ];
    };
  };
}
