{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    doctl
  ];
}
