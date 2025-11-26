{ lib
, config
, pkgs
, ...
}:
let
  dotnetSdks = [
    pkgs.dotnetCorePackages.sdk_6_0
    pkgs.dotnetCorePackages.sdk_8_0
    pkgs.dotnetCorePackages.sdk_9_0
    pkgs.dotnetCorePackages.sdk_10_0
  ];

  dotnetRuntimes = [
    pkgs.dotnetCorePackages.runtime_6_0
    pkgs.dotnetCorePackages.runtime_8_0
    pkgs.dotnetCorePackages.runtime_9_0
  ];

  insecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];

  dotnet-combined = (pkgs.dotnetCorePackages.combinePackages (dotnetSdks ++ dotnetRuntimes)).overrideAttrs (finalAttrs: previousAttrs: {
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
      pkgs.csharpier
    ];

    home.sessionVariables = {
      DOTNET_ROOT = "${dotnet-combined}";
    };

    nixpkgs.config.permittedInsecurePackages = insecurePackages;
  };
}
