{ lib, config, pkgs, ... }: 
{
	options = {
		slack.enable = lib.mkEnableOption "enable slack";
	};

	config = lib.mkIf config.slack.enable {
		programs.slack.enable = true;
	};
}

