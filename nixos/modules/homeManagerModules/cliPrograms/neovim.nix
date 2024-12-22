{ lib, config, pkgs, ... }:

{
  options = {
    neovim.enable 
      = lib.mkEnableOption "enable neovim module";
  };

    config = lib.mkIf config.neovim.enable {
    	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};
    };
}
