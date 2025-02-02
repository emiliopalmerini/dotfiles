{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./docker
      ./ghostty
      ./mainUser
      ./system
    ];
}
