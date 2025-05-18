{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.tmux;
in {
  options = {
    tmux.enable = mkEnableOption "enable tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      # TODO: binding per muoversi senza soluzione di continuità con nvim
      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set-environment -g COLORTERM "truecolor"
        set-option -g default-shell ${pkgs.zsh}/bin/zsh

        set -g mouse on

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # set vi-mode
        set-window-option -g mode-keys vi

        # Keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';

      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = "set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha";
        }
      ];
    };
  };
}
