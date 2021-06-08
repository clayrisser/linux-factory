{ nixpkgs ? import <nixpkgs> {} }:

nixpkgs.stdenv.mkDerivation rec {
  name = "jam-os";
  buildInputs = [
    nixpkgs.gnumake42
    nixpkgs.gnused
  ];
}
