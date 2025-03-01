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
      php83
      laravel
      php83Packages.composer
      php83Extensions.xdebug
      php83Packages.php-cs-fixer
      vscode-extensions.xdebug.php-debug
  ];
  };
}
