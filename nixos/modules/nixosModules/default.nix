{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./docker
      ./ghostty.nix
    ];
}
