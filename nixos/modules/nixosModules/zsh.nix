{ lib, config, pkgs, ... }:

let
  cfg = config.zsh;
in
{
  options.zsh = {
    enable 
      = lib.mkEnableOption "enable zsh module";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      # enableCompletion = true;
      # syntaxHighlighting.enable = true;
      #
      # shellAliases = {
      #   c = "clear";
      #   g = "git";
      #   m = "mkdir";
      # };
    };
  };
}
