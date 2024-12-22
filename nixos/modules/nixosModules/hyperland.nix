{ pkgs, lib, config, ... }: 
{

	options = {
		hyperland.enable = lib.mkEnableOption "enables hyperland";
	};

	config = lib.mkIf config.hyperland.enable {
		programs.hyprland.enable = true; # enable Hyprland

	};
}
