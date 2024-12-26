{ lib, config, pkgs, ... }: 
{
	options = {
		alacritty.enable = lib.mkEnableOption "enable alacritty module";
	};

	config = lib.mkIf config.alacritty.enable {
		programs.alacritty.enable = true;
	};
}
