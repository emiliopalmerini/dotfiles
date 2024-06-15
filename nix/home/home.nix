{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
	programs.home-manager.enable = true;

	home.username = "prometeo";
	home.homeDirectory = "/home/prometeo";
	xdg.enable = true;

	xdg.configFile.nvim.source = mkOutOfStoreSymlink "/home/prometeo/.dotfiles/.config/nvim";
	xdg.dataFile.password-store.source = mkOutOfStoreSymlink "/home/prometeo/.password-store";
	
	home.packages = with pkgs; [
	];

	home.stateVersion = "23.11";

	programs = {
		tmux = (import ./tmux.nix { inherit pkgs; });
		zsh = (import ./zsh.nix { inherit config pkgs; });
		neovim = (import ./neovim.nix { inherit config pkgs; });
		git = (import ./git.nix { inherit config pkgs; });
		zoxide = (import ./zoxide.nix { inherit pkgs; });
		password-store = (import ./pass.nix { inherit pkgs; });
		fzf = (import ./fzf.nix { inherit pkgs; });
	};
}
