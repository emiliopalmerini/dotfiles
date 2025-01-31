{ lib, config, pkgs, ... }:

{
  options = {
    todoist.enable = 
      lib.mkEnableOption "enable todoist";
  };

    config = lib.mkIf config.todoist.enable {
    home.packages = with pkgs; [
      todoist
    ];
    };
}
