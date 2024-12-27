{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bruno.nix
    ./postman.nix
  ];
}

