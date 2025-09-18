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

## Key Bindings
- **Pane navigation**: `h/j/k/l` - Vi-style pane selection
- **Window navigation**: `Alt-Shift-H/L` - Previous/next window
- **Split panes**: `"` (vertical), `%` (horizontal) - Preserve current directory
- **Copy mode**: `v` (begin selection), `C-v` (rectangle toggle), `y` (copy and cancel)

## Plugins
- `tmux-yank`: easy copy to system clipboard
- `vim-tmux-navigator`: seamless navigation between Vim and tmux
- `sensible`: tmux sensible defaults
- `tokyo-night-tmux`: Tokyo Night theme for statusline
