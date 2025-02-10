{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.vscode;
in
{
  options.vscode = {
    enable = mkEnableOption "Enable vscode module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
      vscode-extensions.ms-dotnettools.csharp
      vscode-extensions.csharpier.csharpier-vscode
      vscode-extensions.ms-dotnettools.vscodeintellicode-csharp
    ];
  };
}
