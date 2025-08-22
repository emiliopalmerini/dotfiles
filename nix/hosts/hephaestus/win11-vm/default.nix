{ pkgs }:

let
  includeVpn = builtins.pathExists ./vpn.json;
  vpnArg = if includeVpn then " vpn.json=${./vpn.json}" else "";
in
pkgs.runCommand "autounattend.iso" {
  nativeBuildInputs = [ pkgs.cdrkit ];
} ''
  genisoimage -quiet \
    -V AUTOUNAT \
    -o $out \
    -graft-points \
      Autounattend.xml=${./Autounattend.xml} \
      setup.ps1=${./scripts/setup.ps1}${vpnArg}
''
