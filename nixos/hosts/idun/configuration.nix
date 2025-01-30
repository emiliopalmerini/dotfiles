{ config, pkgs, inputs, ... }:

{
	environment.systemPackages = with pkgs; [
		neovim
		git
	];
	services.nix-daemon.enable = true;
	nix.settings.experimental-features = "nix-command flakes";
	programs.zsh.enable = true;
	system.stateVersion = 5;

	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users."Emilio Palmerini" = import ./hosts/idun/home.nix;

	environment.variables = {
		EDITOR = "nvim";
		TERM = "xterm-256color";
	};

	ghostty.enable = true;
	docker.enable = true;

	nixpkgs.hostPlatform = "aarch64-darwin";
}
