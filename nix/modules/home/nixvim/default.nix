{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.nixvim;
in
{
  options.nixvim = {
    enable = mkEnableOption "Enable nixvim module";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      colorschemes.tokyonight.enable = true;
      plugins.lualine.enable = true;
    };
  };
}
