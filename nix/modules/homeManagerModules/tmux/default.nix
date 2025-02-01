{ lib, config, pkgs, ... }:
{
  options = {
    tmux.enable 
      = lib.mkEnableOption "enable tmux";
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g default-terminal "screen-256color"
      set-option -g default-shell /bin/zsh
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

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window


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
        tmuxPlugins.cpu
        tmuxPlugins.resurrect
        tmuxPlugins.vim-tmux-navigator
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = "set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha";
        }
      ];
      # config = lib.mkIf isMacOS {
      #     # Aggiungi qui le configurazioni specifiche per macOS
      #     extraConfig = ''
      #     set -g default-terminal "screen-256color"
      #     '';
      #   };
    };
  };
}
