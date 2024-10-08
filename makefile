nix:
	@nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/.config/nix#macos
