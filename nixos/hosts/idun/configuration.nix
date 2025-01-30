{ config, pkgs, inputs, utils, ... }:

{
	environment.systemPackages = with pkgs; [
          neovim
          git
	];

	services.nix-daemon.enable = true;

	nix.settings.experimental-features = "nix-command flakes";

	system.stateVersion = 5;

	programs.zsh.enable = true;
        # users.users.emiliopalmerini = {
        #   home = /Users/emiliopalmerini;
        #   shell = pkgs.zsh;
        # };

	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users.emiliopalmerini = import ./home.nix;

	environment.variables = {
		EDITOR = "nvim";
		TERM = "xterm-256color";
	};

	nixpkgs.hostPlatform = "aarch64-darwin";
}
