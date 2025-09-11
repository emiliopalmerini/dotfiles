{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.ghostty;
  isLinux = pkgs.stdenv.isLinux;
in
{
  options.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty module";
  };

  config = lib.mkIf cfg.enable {
    # Use Nix package on Linux, Homebrew on macOS
    home.packages = lib.optionals isLinux [ inputs.ghostty.packages.${pkgs.system}.default ];

    xdg.configFile."ghostty/config".text = ''
      theme = tokyonight-storm
      shell-integration = zsh
    '';
  };
}
