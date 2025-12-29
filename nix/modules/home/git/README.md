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
- Editor: `nvim`, default branch: `main`, rebase on pull, prune on fetch, `rerere` enabled
- Better diffs: `diff.algorithm = histogram`, `merge.conflictstyle = zdiff3`
- Global ignore and hooks from `./config/` (resolved via `builtins.toString`)
- LFS filter configured
- Aliases: `a`, `br`, `cm`, `co`, `cp`, `d`, `graph`, `last`, `ph`, `phf` (force-with-lease), `pl`, `sh`, `st`, `t`, `unstage`
- Includes `git-absorb` for autosquash workflows

## Hooks

**Warning:** Global hooks apply to all repositories.

- `post-commit`: Auto-appends ticket number from branch name (e.g., `123-feature` → `(#123)`)

## LFS

LFS filter is configured globally but hooks are per-repo. Run `git lfs install` in repos that need it.
