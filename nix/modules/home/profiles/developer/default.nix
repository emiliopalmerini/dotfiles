{ lib, config, ... }:

with lib;
let
  cfg = config.profiles.developer;
in
{
  options.profiles.developer = {
    enable = mkEnableOption "Enable developer profile with core development tools";
    
    enableMongodb = mkOption {
      type = types.bool;
      default = false;
      description = "Enable MongoDB tools";
    };
    
    enableDatabase = mkOption {
      type = types.bool;
      default = false;
      description = "Enable database tools (dbeaver)";
    };
  };

  config = mkIf cfg.enable {
    # Core development stack - present in all hosts
    go.enable = true;
    lazygit.enable = true;
    make.enable = true;
    neovim.enable = true;
    shell.enable = true;
    tmux.enable = true;
    claude.enable = true;  # Claude AI assistant for all developers
    
    # Optional development tools
    mongodb.enable = mkIf cfg.enableMongodb true;
    dbeaver.enable = mkIf cfg.enableDatabase true;
  };
}