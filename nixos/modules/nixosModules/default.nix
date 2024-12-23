{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./main-user.nix
      ./hyperland.nix
    ];
}
