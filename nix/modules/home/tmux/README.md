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
- Zero escape-time (no lag in vim), 50k history limit
- Windows/panes start from 1, auto-renumber on close
- Copy mode uses vi keys; new windows and splits preserve cwd

## Key Bindings
- **Pane navigation**: `C-h/j/k/l` - Via vim-tmux-navigator (works in vim too)
- **Window navigation**: `Alt-Shift-H/L` - Previous/next window
- **New window**: `c` - Preserve current directory
- **Split panes**: `"` (vertical), `%` (horizontal) - Preserve current directory
- **Copy mode**: `v` (begin selection), `C-v` (rectangle toggle), `y` (copy and cancel)

## Plugins
- `tmux-yank`: copy to system clipboard
- `vim-tmux-navigator`: seamless C-hjkl navigation between vim and tmux panes
- `tokyo-night-tmux`: statusline theme
