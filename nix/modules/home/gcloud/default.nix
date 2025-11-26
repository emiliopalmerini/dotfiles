{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gcloud;
in
{
  options.gcloud = {
    enable = mkEnableOption "Google Cloud SDK with GKE auth plugin";
  };

  config = mkIf cfg.enable {
    home.packages = let
      gcloud = pkgs.google-cloud-sdk-gce.withExtraComponents (with pkgs.google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        kubectl
      ]);
    in [
      gcloud
    ];
  };
}
