{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./docker.nix
      ./gnomeBoxes.nix
      ./virtualBox.nix
    ];
}
