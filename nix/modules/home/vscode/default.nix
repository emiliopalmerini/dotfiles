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
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # ms-dotnettools.csharp
        # csharpier.csharpier-vscode
        # ms-dotnettools.vscodeintellicode-csharp
        # ms-dotnettools.vscodeintellicode-csharp
        vscodevim.vim
      ];
    };
  };
}
