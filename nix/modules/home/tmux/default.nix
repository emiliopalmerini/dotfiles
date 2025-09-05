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

        # Vim style pane selection
        bind h select-pane -L
        bind j select-pane -D 
        bind k select-pane -U
        bind l select-pane -R

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        set-option -g default-command "exec zsh"

        # set vi-mode
        set-window-option -g mode-keys vi
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';

      plugins = with pkgs; with tmuxPlugins; [
        yank
        vim-tmux-navigator
        sensible
        tokyo-night-tmux
      ];
    };
  };
}
