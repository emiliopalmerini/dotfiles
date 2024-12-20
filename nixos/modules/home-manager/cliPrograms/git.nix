{ lib, config, pkgs, ... }:

let
  cfg = config.git;
in
{
  options.git = {
    enable 
      = lib.mkEnableOption "enable git module";
  };

    config = lib.mkIf cfg.enable {
    	programs.git = {
		enable = true;
		userName = "emiliopalmerini";
		userEmail = "emilio.palmerini@codiceplastico.com";
	};
    };
}
