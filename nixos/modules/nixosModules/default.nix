{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./main-user.nix
      ./ghostty.nix
      ./dotnet.nix
    ];
}
