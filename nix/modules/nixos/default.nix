{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./docker
      ./ghostty
      ./hyprland
      ./mainUser
      ./system
    ];
}
