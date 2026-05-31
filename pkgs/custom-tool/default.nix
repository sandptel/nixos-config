{ stdenv, ... }:

stdenv.mkDerivation {
  pname = "custom-tool";
  version = "0.1.0";
  src = ./.;

  # Add build inputs and build phases here.

  installPhase = ''
    mkdir -p $out/bin
    # Add install steps here.
  '';
}
