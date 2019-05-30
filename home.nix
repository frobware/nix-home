{ config, pkgs, ... }:

let
  pkgsUnstable = import (
    pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "c8342644cf1cb683ad4d2d3d0973723b6fe23878";
    sha256 = "1l1gzxsal4wcs5wdxkv3qb72wsaxmfx5nnx1yixl41ijdanznbcd";
    }
  ) { };
in
{
  nixpkgs.config.firefox.enableAdobeFlash = false;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    gitFull
    
    ag
    awscli
    file
    gdb
    gnome3.dconf
    htop
    jq
    nix-review
    nmap
    pass
    pinentry
    socat
    tmux
    unzip
    xclip
    xsel
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.htop.enable = true;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  services.emacs = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry}/bin/pinentry-curses
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans 14";
      package = pkgs.dejavu_fonts;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adapta-Nokto-Eta";
      package = pkgs.adapta-gtk-theme;
    };
  };
}
