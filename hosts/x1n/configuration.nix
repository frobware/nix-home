{ config, lib, pkgs, ... }:

{
  imports = [
    ../../config/aws2.nix
  ];

  # Home Manager needs a bit of information about you and the paths it
  # should manage.
  home.username = "aim";
  home.homeDirectory = "/home/aim";

  # home.home-manager.useGlobalPkgs = true;

  # home = {
  #   extraOutputsToInstall = [ "man" ];

  #   # These are packages that should always be present in the user
  #   # environment, though perhaps not the machine environment.
  #   packages = [
  #     (pkgs.callPackage ./../../scripts/switch-to-firefox.nix {})
  #     (pkgs.callPackage ./../../scripts/gnome-toggle-theme.nix {})

  #     pkgs.cacert
  #     pkgs.rlwrap
  #     pkgs.ncdu

  #     # pkgs.idea.idea-community
  #     # pkgs.idea.goland
  #     #pkgs.slack

  #     # Mail
  #     pkgs.afew
  #     pkgs.isync
  #     pkgs.msmtp
  #     pkgs.muchsync
  #     pkgs.notmuch

  #     # Cloud/SDKs
  #     pkgs.awscli
  #     pkgs.google-cloud-sdk
  #     pkgs.azure-cli
  #     pkgs.doctl

  #     #      pkgs.npm2nix

  #     # Shell
  #     pkgs.shfmt

  #     # KDE
  #     pkgs.kdiff3

  #     # Nix
  #     pkgs.nox
  #     pkgs.niv
  #     pkgs.nixfmt
  #     pkgs.nix-info

  #     # for Emacs straight
  #     pkgs.watchexec

  #     # Browsers
  #     # pkgs.google-chrome
  #     # pkgs.firefox

  #     # Development tools
  #     pkgs.gnumake
  #     # pkgs.yaml-language-server
  #     pkgs.shellcheck
  #     pkgs.clang-tools

  #     # Utilities
  #     pkgs.ag
  #     pkgs.gnupg
  #     pkgs.htop
  #     pkgs.ripgrep
  #     pkgs.zlib
  #     pkgs.jq

  #     pkgs.aspell
  #     pkgs.aspellDicts.en
  #     pkgs.aspellDicts.en-computers
  #     pkgs.aspellDicts.en-science
  #     pkgs.hunspell
  #     pkgs.hunspellDicts.en-gb-ise
  #     pkgs.hunspellDicts.en-us
  #     pkgs.ispell
  #     pkgs.languagetool

  #     # k8s
  #     pkgs.fluxctl
  #     pkgs.kube-prompt
  #     pkgs.kubectl
  #     pkgs.kubectx
  #     pkgs.kustomize

  #     # Rust
  #     pkgs.rust-analyzer
  #     pkgs.clippy
  #     pkgs.rls
  #     pkgs.cargo

  #     # Rust-based coreutils
  #     pkgs.dust                 # du
  #     pkgs.exa                  # ls
  #     pkgs.fd                   # find
  #     pkgs.hyperfine            # time
  #     pkgs.procs                # ps
  #     pkgs.sd                   # sed
  #     pkgs.tokei                # wc -l
  #     pkgs.xsv                  # csv
  #     pkgs.zenith               # top

  #     # Kube development
  #     pkgs.cfssl
  #     pkgs.etcd

  #     # Go
  #     pkgs.delve
  #     pkgs.errcheck
  #     pkgs.go
  #     pkgs.go-bindata
  #     pkgs.go2nix
  #     pkgs.gocode
  #     pkgs.godef
  #     #pkgs.goimpl
  #     pkgs.golangci-lint
  #     pkgs.golint
  #     pkgs.gomodifytags
  #     pkgs.gopls
  #     pkgs.gotags
  #     pkgs.gotools
  #     pkgs.gotop

  #     # X11
  #     pkgs.wmctrl
  #     pkgs.xclip
  #     pkgs.xsel

  #   ];

  #   sessionVariables = {
  #     ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
  #     EDITOR = "emacsclient -t -a vi";
  #     VISUAL = "emacsclient -c -a vi";
  #     LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
  #     PASSWORD_STORE_DIR = "${config.xdg.configHome}/password-store";
  #     NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/notmuchrc";
  #     # https://github.com/NixOS/nixpkgs/issues/58132
  #     GIT_SSH = "/usr/bin/ssh";
  #   };

  #   keyboard.options = [ "caps:ctrl_modifier" ];
  #   keyboard.layout = [ "emacs2" ];
  # };

  # programs.direnv.enable = true;
  # programs.man.enable = false;

  # programs.password-store = {
  #   enable = true;
  #   package = pkgs.pass.withExtensions (e: [ e.pass-audit e.pass-otp ]);
  # };
}
