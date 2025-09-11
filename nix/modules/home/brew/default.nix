{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.brew;
in
{
  options = {
    brew.enable = mkEnableOption "Enable brew (Homebrew CLI)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Homebrew is typically installed via the system installer
      # but we can ensure brew command is available in PATH
      # Note: On NixOS, you might want to use the homebrew package
      # On Darwin, homebrew is usually managed at the system level
    ] ++ (if stdenv.isDarwin then [] else [ homebrew ]);

    # Add brew to shell aliases for convenience
    home.shellAliases = {
      "brew-update" = "brew update && brew upgrade";
      "brew-cleanup" = "brew cleanup --prune=all";
      "brew-doctor" = "brew doctor";
    };
  };
}