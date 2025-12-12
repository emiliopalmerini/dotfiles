{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gcloud;
  # Fix google-cloud-sdk to include missing Tcl/Tk dependencies for bundled Python
  google-cloud-sdk-fixed = pkgs.google-cloud-sdk.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.autoPatchelfHook ];
    buildInputs = (old.buildInputs or []) ++ [ pkgs.tcl pkgs.tk ];
    autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or []) ++ [ "libtcl8.6.so" "libtk8.6.so" ];
  });
in
{
  options.gcloud = {
    enable = mkEnableOption "Google Cloud SDK with GKE auth plugin";
  };

  config = mkIf cfg.enable {
    home.packages = let
      gcloud = google-cloud-sdk-fixed.withExtraComponents (with google-cloud-sdk-fixed.components; [
        gke-gcloud-auth-plugin
        kubectl
      ]);
    in [
      gcloud
    ];
  };
}
