{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./docker.nix
      ./ghostty.nix
    ];
}
