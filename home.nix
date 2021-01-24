{ config, lib, pkgs, ... }:

{
  imports = import home/module-list.nix;

  # targets.genericLinux.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aim";
  home.homeDirectory = "/home/aim";

  nixpkgs.config = import ./config.nix;

  programs.home-manager = {
    enable = true;
  };

  programs.command-not-found.enable = true;

  systemd.user.startServices = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
