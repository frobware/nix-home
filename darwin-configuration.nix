{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    [
      pkgs.ag
      #pkgs.emacs
      pkgs.vim
      pkgs.wget
      pkgs.home-manager
      pkgs.gnupg
      pkgs.direnv
      pkgs.pinentry
      pkgs.alacritty
      pkgs.pinentry_mac
      # pkgs.pinentry

      pkgs.autoconf
      pkgs.watchexec

      pkgs.awscli2
      pkgs.google-cloud-sdk
      pkgs.azure-cli
      pkgs.pass

      pkgs.go
      pkgs.gopls

      pkgs.htop
      pkgs.tmux

      pkgs.tree

      # pkgs.rust
      # pkgs.cargo
      pkgs.wireshark
      pkgs.termshark
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  #services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  #   grabKeyboardAndMouse = false;
  #   pinentryFlavor = "tty";
  #   extraConfig = ''
  #     allow-loopback-pinentry
  #     allow-emacs-pinentry
  #   '';
  # };

  nix.useDaemon = false;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSWindowResizeTime = "0.01";
  system.defaults.dock.orientation = "right";

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.info.enable = true;
  documentation.doc.enable = true;
}
