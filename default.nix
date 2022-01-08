{ nixpkgs ? import <nixpkgs> {} }:

nixpkgs.stdenv.mkDerivation rec {
  name = "packages";
  LOCALE_ARCHIVE_2_27 = "${nixpkgs.glibcLocales}/lib/locale/locale-archive";
  LOCALE_ARCHIVE_2_11 = "${nixpkgs.glibcLocales}/lib/locale/locale-archive";
  LANG = "en_US.UTF-8";
  buildInputs = [
    nixpkgs.cloc
    nixpkgs.gnumake42
    nixpkgs.gnused
    nixpkgs.jq
  ];
}
