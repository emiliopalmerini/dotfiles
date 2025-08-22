{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.win11vm;
in {
  options.win11vm = {
    enable = mkEnableOption "Enable Windows 11 VM integration options";

    installerIsoPath = mkOption {
      type = types.path;
      default = "/var/lib/libvirt/isos/windows11.iso";
      description = "Absolute path to the Windows 11 installer ISO.";
    };

    autounattendIsoPath = mkOption {
      type = types.path;
      default = "/var/lib/libvirt/isos/autounattend.iso";
      description = "Absolute path to the generated Autounattend ISO.";
    };
  };

  config = mkIf cfg.enable {
    # Export Terraform variables so `terraform apply` picks them up automatically
    environment.variables = {
      TF_VAR_win_iso_path = toString cfg.installerIsoPath;
      TF_VAR_autounattend_iso_path = toString cfg.autounattendIsoPath;
    };
  };
}

