{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-darwin.url = "github:LnL7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
		let
			# Sistemi definiti
			linuxSystem = "x86_64-linux";
			macSystem = "aarch64-darwin";

			# Pacchetti per i sistemi
			linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};
			macPkgs = nixpkgs.legacyPackages.${macSystem};

			# Configurazione per il Mac
			macConfiguration = { pkgs, ... }: {
				nixpkgs.config.allowUnfree = true;
				environment.systemPackages = [
					pkgs.neovim
					pkgs.discord
					pkgs.tmux
					pkgs.obsidian
				];

				fonts.packages = [
					(pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
				];

				services.nix-daemon.enable = true;

				nix.settings.experimental-features = "nix-command flakes";

				system.configurationRevision = self.rev or self.dirtyRev or null;
				system.stateVersion = 5;
			};

			# Configurazione per Linux
			linuxConfiguration = {
				imports = [
					./hosts/default/configuration.nix
					inputs.home-manager.nixosModules.default
				];
			};
		in
			{
			nixosConfigurations = {
				default = nixpkgs.lib.nixosSystem {
					system = linuxSystem;
					specialArgs = { inherit inputs; };
					modules = [ linuxConfiguration ];
				};

				codicePlastico = nixpkgs.lib.nixosSystem {
					system = linuxSystem;
					specialArgs = { inherit inputs; };
					modules = [
						./hosts/codicePlastico/configuration.nix
						inputs.home-manager.nixosModules.default
					];
				};
			};

			darwinConfigurations = {
				macbook = nix-darwin.lib.darwinSystem {
					system = macSystem;
					modules = [ macConfiguration ];
				};
			};
		};
}
