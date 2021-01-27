{ lib, config, pkgs, ... }:

let

  inherit (lib) optional optionalAttrs mkIf mkMerge mkDefault flatten optionals;

in

{
  imports = [
    ../config/aws2.nix
    ../config/azure.nix
    ../config/digitalocean.nix
    ../config/docker.nix
    ../config/fonts.nix
    ../config/gcloud.nix
    ../config/go.nix
    ../config/rust.nix
    ../config/kubernetes.nix

    ../profiles/workstation.nix
  ];

  environment.systemPackages = with pkgs; [
    mercurial
    ncdu
    gnupg
    podman
    diffutils
  ];
}
