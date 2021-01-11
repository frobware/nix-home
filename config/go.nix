{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    goimports
    gopls
    go
  ];
}
