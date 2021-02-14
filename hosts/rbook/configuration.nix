{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/workstation.nix
    ../../profiles/desktop.nix
  ];

  # https://github.com/LnL7/nix-darwin/issues/165#issuecomment-749682749
  # environment.etc = {
  #   "sudoers.d/10-nix-commands" = {
  #     text = ''
  #       %admin ALL=(ALL:ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild, \
  #       /run/current-system/sw/bin/nix*, \
  #       /run/current-system/sw/bin/ln, \
  #       /nix/store/*/activate, \
  #       /bin/launchctl
  #     '';
  #   };
  # };

  nixpkgs.config.allowUnsupportedSystem = false;
  nixpkgs.config.allowUnfree = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  #services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  # system.stateVersion = 4;

  nix.useDaemon = false;

  # programs.gnupg.agent.enable = true;
  # programs.gnupg.agent.enableSSHSupport = true;

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSWindowResizeTime = "0.001";
  system.defaults.dock.orientation = "right";

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.info.enable = true;
  documentation.doc.enable = true;

  home-manager.users.amcdermo = {
    programs.direnv.enable = true;
    programs.autojump.enable = true;
  };
}
