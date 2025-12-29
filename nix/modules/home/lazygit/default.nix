{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.lazygit;
in
{
  options = {
    lazygit.enable = mkEnableOption "Enable Lazygit";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.lazygit ];

    home.file.".config/lazygit/config.yml".text = ''
      gui:
        theme:
          activeBorderColor:
            - '#7aa2f7'
            - bold
          inactiveBorderColor:
            - '#444a73'
        showIcons: true
        nerdFontsVersion: "3"
      git:
        paging:
          colorArg: always
          pager: delta --paging=never
      keybinding:
        universal:
          quit: 'q'
          quit-alt1: '<c-c>'
    '';
  };
}
