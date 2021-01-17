{ config, pkgs, ... }:

{
  imports = [
    ../config/go.nix
    ../config/rust.nix
  ];
}
