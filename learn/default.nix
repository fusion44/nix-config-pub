{pkgs ? import <nixpkgs> {}}: let
  uname = "lnbits";
  repo = "lnbits_legend";
  src = import ./meta.nix {inherit uname repo;};
in
  stdenv.mkDerivation {
    inherit uname repo src;
  }
