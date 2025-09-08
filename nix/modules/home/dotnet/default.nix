{ lib
, config
, pkgs
, ...
}: {
  options.dotnet.enable = lib.mkEnableOption "Enable .NET SDKS";

  config = lib.mkIf config.dotnet.enable {
    home.packages =
      let
        dotnet-combined = (with pkgs.dotnetCorePackages; combinePackages [
          sdk_6_0
          sdk_8_0
          sdk_9_0
        ]).overrideAttrs (finalAttrs: previousAttrs: {
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
      [
        dotnet-combined
        pkgs.dotnetPackages.Nuget
        pkgs.netcoredbg
      ];

    home.sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnetCorePackages.combinePackages [ pkgs.dotnetCorePackages.sdk_6_0 pkgs.dotnetCorePackages.sdk_8_0 pkgs.dotnetCorePackages.sdk_9_0 ]}";
    };

    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "dotnet-runtime-6.0.36"
    ];
  };
}
