{ lib, config, pkgs, ... }: 
{
	options = {
		dotnet.enable = lib.mkEnableOption "enable kitty module";
	};

	config = lib.mkIf config.dotnet.enable {
		# Pacchetti da includere nell'ambiente
		home.packages = (with pkgs.dotnetCorePackages; [
			sdk_6_0
			sdk_7_0
		]);

		# Variabili di ambiente
		home.sessionVariables = {
			DOTNET_CLI_HOME = "${config.home.homeDirectory}/.dotnet";
			DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_7_0}/share/dotnet";
		};

		# Hook di shell per migliorare l'ambiente
		home.shell.initExtra = ''
	export PATH="$PATH:${config.home.homeDirectory}/.dotnet/tools"
		'';
	};
}
