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
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        c = "clear";
        g = "git";
        m = "mkdir";
      };

      initExtra = '' 
        eval "$(oh-my-posh init zsh)"
        '';
    };

    programs.oh-my-posh.enable = true;
    programs.oh-my-posh.enableZshIntegration = true;
  };
}
