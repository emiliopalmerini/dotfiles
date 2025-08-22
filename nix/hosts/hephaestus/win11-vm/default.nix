{ pkgs }:

pkgs.runCommand "autounattend.iso" {
  nativeBuildInputs = [ pkgs.cdrkit ];
} ''
  genisoimage -quiet \
    -V AUTOUNAT \
    -o $out \
    -graft-points \
      Autounattend.xml=${./Autounattend.xml} \
      setup.ps1=${./scripts/setup.ps1}
''

