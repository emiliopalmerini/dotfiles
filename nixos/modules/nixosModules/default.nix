{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./apiClients
      ./main-user.nix
      ./docker.nix
      ./dotnet.nix
      ./ghostty.nix
      ./mongodbClients.nix
    ];
}
