{ config, lib, pkgs, ... }:

with lib;

{
  programs.gnome-terminal = {
    showMenubar = false;
    themeVariant = "system";
    profile = {
      "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
        default = true;
        visibleName = "frobware";
        cursorShape = "block";
        showScrollbar = false;
      };
    };
  };
}
