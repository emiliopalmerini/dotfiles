{ lib, config, pkgs, ... }:
{
  options = {
    tmux.enable 
      = lib.mkEnableOption "enable tmux";
  };

    config = lib.mkIf config.tmux.enable {
    	programs.tmux = {
		enable = true;
	};
    };
}
