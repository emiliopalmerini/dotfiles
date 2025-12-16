{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gcloud;
  # Fix google-cloud-sdk bundled Python missing tcl/tk dependencies
  # by adding them to buildInputs and ignoring missing deps.
  # This is a temporary workaround until the fix from nixpkgs PR#469521
  # reaches the nixpkgs version being used.
  google-cloud-sdk-fixed = pkgs.google-cloud-sdk.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [ pkgs.tcl-8_6 pkgs.tk ];
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.autoPatchelfHook ];
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
