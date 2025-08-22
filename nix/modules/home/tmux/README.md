# Tmux Home Manager Module

Configures tmux with sane defaults, vi-like navigation, and useful plugins.

## Enable
```
{
  imports = [ ../../modules/home ];
  tmux.enable = true;
}
```

## Features
- `sensibleOnTop`, true-color support, mouse enabled
- Vi-style pane selection (`h/j/k/l`), windows/panes start from 1
- Window navigation with `Alt-Shift-H/L`
- Default shell: `zsh`
- Copy mode uses vi keys; split commands preserve cwd

## Plugins
- `tmux-yank`: easy copy to system clipboard
- `vim-tmux-navigator`: seamless navigation between Vim and tmux
- `sensible`: tmux sensible defaults
- `catppuccin`: theme (flavor `mocha`)

