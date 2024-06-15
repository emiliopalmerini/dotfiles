# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, outputs, config, lib, pkgs, meta, ... }:
{
	imports = [ 
		./modules/languages.nix
	];

	nix = {
		package = pkgs.nixFlakes;
		extraOptions = ''
			experimental-features = nix-command flakes
			'';
	};


	nixpkgs = {
		overlays = [
			outputs.overlays.additions
			outputs.overlays.unstable
		];
		config = {
			permittedInsecurePackages = [
				"electron-25.9.0"
			];
		};
	};

	nixpkgs.config.allowUnfree = true;


	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = meta.hostname;
	time.timeZone = "Europe/Rome";

	i18n.defaultLocale = "en_US.UTF-8";

	fonts.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
			openmoji-color
	];

	users.users.prometeo = {
		isNormalUser = true;
		extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
			packages = with pkgs; [];
		shell = pkgs.zsh;
	};

	environment.systemPackages = with pkgs; [
			neovim 
			wget
			fzf
			fd
			jq
			lua-language-server
			tmux
			ripgrep
			wl-clipboard
			stow
			glib
			gopls
			eza
			bat
			wl-clipboard
			zoxide
			pass
			docker-compose
	];

	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

	programs.zsh.enable=true;

	virtualisation.docker.enable = true;

	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = true;
			AllowUsers = null; 
			UseDns = true;
			X11Forwarding = false;
			PermitRootLogin = "yes";
		};  
	};

	services.plex = {
		enable = true;
		openFirewall = true;
		user="prometeo";
	};

	networking.firewall.allowedTCPPorts = [ 6011 6081 8123 ];

	virtualisation.oci-containers = {
		backend = "docker";
		containers.homeassistant = {
			volumes = [ "home-assistant:/config" ];
			environment.TZ = "Europe/Berlin";
			image = "ghcr.io/home-assistant/home-assistant:stable";
			extraOptions = [ "--network=host" ];
		};
	};

	system.stateVersion = "24.05"; # Did you read the comment?

}

