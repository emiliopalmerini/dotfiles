{ lib, config, pkgs, ... }:

let
  cfg = config.neovim;
in
{
  options.neovim = {
    enable 
      = lib.mkEnableOption "enable neovim module";
  };

    config = lib.mkIf cfg.enable {
    	programs.neovim = {
		enable = true;
	};
    };
}
