{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 5;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.enable = true;

  users.users.emiliopalmerini = {
    home = /Users/emiliopalmerini;
    shell = pkgs.zsh;
  };

  homebrew.enable = true;

  home-manager = {
    # useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "backup";
    users = {
      "emiliopalmerini" = import ./home.nix;
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
