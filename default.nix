{ nixpkgs ? import <nixpkgs> {} }:

nixpkgs.stdenv.mkDerivation rec {
  name = "deb-distro";
  buildInputs = [
    nixpkgs.cloc
    nixpkgs.gnumake42
    nixpkgs.gnused
  ];
}
