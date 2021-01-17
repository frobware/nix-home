{ lib, config, pkgs, ... }:

let

  inherit (lib) optional optionalAttrs mkIf mkMerge mkDefault flatten optionals;

in

{
  imports = [
    ../config/fonts.nix
  ];
}
