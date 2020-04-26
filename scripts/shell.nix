{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ (pkgs.callPackage ./gnome-toggle-theme.nix {}) ];
}
