{ pkgs, ... }:

{
  imports = [
    ./gnome-toggle-theme.nix { }
    ./switch-to-firefox.nix { }
  ];
}
