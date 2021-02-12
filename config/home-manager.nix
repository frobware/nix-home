{ lib, pkgs, ... }:

{
  imports = [
    ./home-manager/bash.nix
    ./home-manager/git.nix
    ./home-manager/tmux.nix
    ./home-manager/zsh.nix
    ./home-manager/alacritty.nix
    ./home-manager/pinentry.nix
  ];
}
