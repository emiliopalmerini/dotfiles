{ lib
, config
, pkgs
, ...
}:
let
  dotnetSdks = with pkgs.dotnetCorePackages; [
    sdk_6_0
    sdk_7_0
    sdk_8_0
    sdk_9_0
  ];

  insecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
    "dotnet-sdk-7.0.410"
  ];

  dotnet-combined = (pkgs.dotnetCorePackages.combinePackages dotnetSdks).overrideAttrs (finalAttrs: previousAttrs: {
    postBuild = (previousAttrs.postBuild or "") + ''
      for i in $out/sdk/*
      do
        i=$(basename $i)
        mkdir -p $out/metadata/workloads/''${i/-*}
        touch $out/metadata/workloads/''${i/-*}/userlocal
      done
    '';
  });
in
{
  options.dotnet.enable = lib.mkEnableOption "Enable .NET SDKS";

  config = lib.mkIf config.dotnet.enable {
    home.packages = [
      dotnet-combined
      pkgs.dotnetPackages.Nuget
      pkgs.netcoredbg
    ];

    home.sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnetCorePackages.combinePackages dotnetSdks}";
    };

    nixpkgs.config.permittedInsecurePackages = insecurePackages;
  };
}
