{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../config/docker.nix
    ../config/aws2.nix
    ../config/azure.nix
    ../config/gcloud.nix
    ../profiles/desktop.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    kubectl
    minikube
  ];
}
