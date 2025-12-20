{ pkgs, userConfig, ... }:
{
  imports = [
    ./../../modules/home
  ];

  # Base Home Manager configuration
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;


  # Core developer tools (complex modules with configs)
  go.enable = true;
  neovim.enable = true;
  shell.enable = true;
  tmux.enable = true;
  nodejs.enable = true;

  # macOS specific session path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = [
    # Development tools
    pkgs.lazygit
    pkgs.gnumake
    pkgs.gcc
    pkgs.zig
    pkgs.lua
    pkgs.hugo

    # Version control and collaboration
    pkgs.graphite-cli

    # Database tools
    pkgs.mongosh
    pkgs.mongodb-tools

    # Docker management
    pkgs.lazydocker

    # Media tools
    pkgs.ffmpeg
    pkgs.python313Packages.markitdown

    # macOS utilities
    pkgs.mas
    pkgs.clamav

    # IDEs and editors
    pkgs.code-cursor
  ];

  # Dotfiles management
  home.file = {
    ".config/ghostty/config".text = ''
      font-family = "Hack Nerd Font Mono"
      font-feature = -calt -liga -dlig
      theme = tokyonight-storm
    '';

    # Lazygit configuration
    ".config/lazygit/config.yml".text = ''
      gui:
        theme:
          activeBorderColor:
            - '#7aa2f7'
            - bold
          inactiveBorderColor:
            - '#444a73'
        showIcons: true
        nerdFontsVersion: "3"
      git:
        paging:
          colorArg: always
          pager: delta --paging=never
      keybinding:
        universal:
          quit: 'q'
          quit-alt1: '<c-c>'
    '';

    # Ripgrep configuration
    ".ripgreprc".text = ''
      # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
      --max-columns=150
      --max-columns-preview

      # Add file types
      --type-add=web:*.{html,css,js,jsx,ts,tsx}

      # Using glob patterns to include/exclude files or folders
      --glob=!.git/*
      --glob=!node_modules/*
      --glob=!*.lock
      --glob=!package-lock.json

      # Search hidden files by default
      --hidden

      # Smart case search
      --smart-case
    '';

    # Global gitignore
    ".gitignore_global".text = ''
      # macOS
      .DS_Store
      .AppleDouble
      .LSOverride

      # Editor directories and files
      .idea
      .vscode
      *.swp
      *.swo
      *~

      # Logs
      *.log

      # Environment variables
      .env
      .env.local
      .env.*.local

      # Dependencies
      node_modules/
      vendor/

      # Build outputs
      dist/
      build/
      *.out

      # Nix
      result
      result-*
    '';
  };

  # Git configuration with global gitignore
  programs.git = {
    enable = true;
    userName = "emiliopalmerini";
    userEmail = userConfig.email;

    extraConfig = {
      core = {
        excludesfile = "~/.gitignore_global";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };

  # Delta for better git diffs
  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
      theme = "tokyonight_storm";
    };
  };
}
