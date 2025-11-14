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
- fzf-tab plugin pinned at version v1.1.2
- History configuration: deduplication, ignore space/dups, no beep
- Completion: case-insensitive matching, colorized, fzf-tab for `cd` and `z`

## Packages
Installs `bat`, `jq`, `jqp`, `httpie`, `rg`, `tree`, `gh` (GitHub CLI) and integrates `fzf`, `zoxide`, `oh-my-posh`.

## Notes
- Shell configuration uses `initContent` field for custom Zsh initialization code
- The module enables completion, autosuggestion, and syntax highlighting via Home Manager options

