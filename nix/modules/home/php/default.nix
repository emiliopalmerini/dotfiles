{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.php;
in
{
  options.php = {
    enable = mkEnableOption "Enable php module";
  };

  config = mkIf cfg.enable {
  home.packages = with pkgs; [
      php84
      php84Packages.composer
      php84Extensions.xdebug
      php84Packages.php-cs-fixer
      vscode-extensions.xdebug.php-debug
      laravel
  ];
  };
}
