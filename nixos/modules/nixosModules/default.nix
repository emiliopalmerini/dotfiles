{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./apiClients
      ./virtualizations
      ./dotnet.nix
      ./ghostty.nix
      ./main-user.nix
      ./mongodbClients.nix
    ];
}
