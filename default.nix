{ nixpkgs ? import <nixpkgs> {} }:

nixpkgs.stdenv.mkDerivation rec {
  name = "jam-os";
  buildInputs = [
    nixpkgs.cloc
    nixpkgs.gnumake42
    nixpkgs.gnused
  ];
}
