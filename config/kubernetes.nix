{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fluxctl
    kube-prompt
    kubectl
    kubectx
    kustomize

    # Kube development
    cfssl
    etcd
    gnutar                      # on darwin
  ];
}
