{ lib, config, pkgs, ... }:

let
  cfg = config.zsh;
  myAliases = {
    c = "clear";
    g = "git";
    m = "mkdir";
    ls = "ls --color";
  };
  oh-my-posh-config = ./oh-my-posh.json;
in
{
  options.zsh = {
    enable = lib.mkEnableOption "enable zsh module";
  };

  config = lib.mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile oh-my-posh-config)); 
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = myAliases ;

      initExtra = '' 
        eval "$(oh-my-posh init zsh)"
        '';
    };

  };
}
