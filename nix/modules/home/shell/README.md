# Shell Home Manager Module (Zsh)

Zsh-centric shell setup with Oh My Posh, zoxide, fzf, and helpful aliases.

## Enable
```
{
  imports = [ ../../modules/home ];
  shell.enable = true;
}
```

## Features
- Aliases: `cd -> z`, `bat` as `cat`
- Oh My Posh prompt with config from `oh-my-posh.json`
- zoxide + fzf with Zsh integration
- Autosuggestions and syntax highlighting
- macOS Homebrew environment sourcing if present
- ZLE keybindings: `Ctrl-Y` yank, `Ctrl-p/n` history search
- fzf-tab plugin pinned at a specific version

## Packages
Installs `bat`, `jq`, `jqp`, `httpie`, `rg`, `tree` and integrates `fzf`, `zoxide`, `oh-my-posh`.

