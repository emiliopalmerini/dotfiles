{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./main-user.nix
      ./docker.nix
      ./dotnet.nix
      ./ghostty.nix
      ./mongodb.nix
    ];
}
