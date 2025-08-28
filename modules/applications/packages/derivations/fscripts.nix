{ pkgs, scripts, ... }:
pkgs.stdenv.mkDerivation {
  name = "my-scripts";
  src = scripts;
  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* $out/bin
    chmod +x $out/bin
  '';
}
