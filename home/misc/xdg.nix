{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.home) homeDirectory;
  inherit (config.xdg) configHome;
in {
  # xdg = {
  #   enable = true;
  #   configHome = "${homeDirectory}/.config";
  #   dataHome = "${homeDirectory}/.local/share";
  #   cacheHome = "${homeDirectory}/.cache";
  # };

  xdg.userDirs = {
    enable = true;
    desktop = "${homeDirectory}/desktop";
    documents = "${homeDirectory}/documents";
    download = "${homeDirectory}/net";
    music = "${homeDirectory}/media/muscic";
    pictures = "${homeDirectory}/media/pictures";
    publicShare = "${homeDirectory}/public";
    templates = "${configHome}/templates";
    videos = "${homeDirectory}/media/videos";
  };
}
