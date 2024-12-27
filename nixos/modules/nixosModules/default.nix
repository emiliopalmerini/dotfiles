{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./main-user.nix
      ./dotnet.nix
      ./ghostty.nix
      ./mongodb.nix
    ];
}
