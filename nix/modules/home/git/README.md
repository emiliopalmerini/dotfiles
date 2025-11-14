# Git Home Manager Module

Opinionated Git setup with aliases, sensible defaults, and optional LFS filter. Exposes `userName` and `userEmail` options.

## Enable
```
{
  imports = [ ../../modules/home ];
  git.enable = true;
  git.userName = "Your Name";
  git.userEmail = "you@example.com";
}
```

## Features
- Sets editor to `nvim`, default branch to `main`, prune on fetch, rebase on pull, enables `rerere`.
- Global ignore file sourced from this repo:
  - `nix/modules/home/git/config/.gitignore_global`
- Git hooks directory: `nix/modules/home/git/config/hooks`
- LFS filter configured (requires `git-lfs` if you plan to use it).
- Handy aliases: `cm`, `co`, `br`, `ph`, `phf`, `pl`, `unstage`, `last`, `gh`, `graph`, `st`, `sh`.
- Installs `git-absorb` to turn fixups into autosquash commits.
- Configuration uses `programs.git.settings` structure (not `config`).

## Notes
- Paths are resolved relative to the repo: `config` directory is used for the global ignore file.
- If you maintain dotfiles in a different location, update the module accordingly.
