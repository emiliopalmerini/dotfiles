{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hyperland.nix
      ./main-user.nix
    ];
}
