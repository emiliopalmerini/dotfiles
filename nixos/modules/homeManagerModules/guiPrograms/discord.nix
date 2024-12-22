{ lib, config, pkgs, ... }: 
{
	options = {
		discord.enable = lib.mkEnableOption "enable discord";
	};

	config = lib.mkIf config.discord.enable {
		programs.discord.enable = true;
	};
}

