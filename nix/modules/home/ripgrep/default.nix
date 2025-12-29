{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.ripgrep;
in
{
  options = {
    ripgrep.enable = mkEnableOption "Enable Ripgrep";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.ripgrep ];

    home.sessionVariables = {
      RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    };

    home.file.".ripgreprc".text = ''
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
  };
}
