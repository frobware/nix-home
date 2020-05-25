{ pkgs ? import <nixpkgs> {},
  super ? import <nixpkgs> {}
}:

with pkgs;

rec {
  xdwim = callPackage ./xdwim {};
  goreftools = callPackage ./goreftools {};
}
