{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    awscli
  ];
}
