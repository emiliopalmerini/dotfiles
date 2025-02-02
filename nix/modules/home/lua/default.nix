{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.lua;
in 
{
  options.lua = {
    enable = mkEnableOption "Enable Lua programming language";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pkgs.lua  
    ];
  };
}

