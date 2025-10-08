{ pkgs, inputs, ... }:
pkgs.stdenv.mkDerivation {
  name = "my-scripts";
  src = inputs.scripts;
  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* $out/bin
    chmod +x $out/bin
  '';
}
