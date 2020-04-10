{ config, lib, pkgs, ... }:

let
  locale = "en_US.UTF-8";
  home_directory = builtins.getEnv "HOME";
  tmp_directory = "/tmp";
  ca-bundle_crt = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  custom-golist = pkgs.callPackage pkgs/golist { };
in rec {
  fonts.fontconfig.enable = true;

  programs.home-manager = {
    enable = true;
    path = "./home-manager";
  };

  imports = [
    ./programs/bash
  ];
  
  programs.command-not-found.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage when a
  # new Home Manager release introduces backwards incompatible
  # changes.
  #
  # You can update Home Manager without changing this value. See the
  # Home Manager release notes for a list of state version changes in
  # each release.
  home.stateVersion = "19.09";

  home = {
    # These are packages that should always be present in the user
    # environment, though perhaps not the machine environment.
    packages = [
      # Nix
      pkgs.nox
      pkgs.niv
      pkgs.nixfmt

      # Development tools
      pkgs.gnumake
      pkgs.strace

      # Grep
      pkgs.ag
      pkgs.ripgrep

      pkgs.gnupg
      pkgs.zlib

      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.aspellDicts.en-computers
      pkgs.aspellDicts.en-science
      pkgs.hunspell
      pkgs.hunspellDicts.en-gb-ise
      pkgs.hunspellDicts.en-us
      pkgs.ispell
      pkgs.languagetool

      # jetbrains.idea-ultimate

      # k8s
      pkgs.fluxctl
      pkgs.kube-prompt
      pkgs.kubectl
      pkgs.kubectx
      pkgs.kubernetes-helm
      pkgs.kustomize

      # Go
      pkgs.errcheck
      pkgs.go
      pkgs.go-bindata
      pkgs.go2nix
      pkgs.gocode
      pkgs.godef
      pkgs.golangci-lint
      pkgs.golint
      pkgs.gotags
      pkgs.gotools # gopls
      pkgs.gotop
      custom-golist

      pkgs.wmctrl

      # Fonts
      # pkgs.corefonts
      # pkgs.vistafonts
      pkgs.dejavu_fonts
      pkgs.emojione
      pkgs.fira-mono
      pkgs.font-awesome-ttf
      pkgs.fontconfig
      pkgs.nerdfonts
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-extra
      pkgs.roboto
      pkgs.source-code-pro
      pkgs.source-sans-pro
      pkgs.source-serif-pro
      pkgs.twemoji-color-font
    ];

    sessionVariables = {
      ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
      EDITOR = "emacsclient -t -a vi";
      VISUAL = "emacsclient -c -a vi";
      LESSHISTFILE = "${xdg.cacheHome}/less/history";
      LOCATE_PATH = "${xdg.cacheHome}/locate/home.db:${xdg.cacheHome}/locate/system.db";
      PASSWORD_STORE_DIR = "${xdg.configHome}/password-store";
    };

    # keyboard.options = [ "caps:ctrl_modifier" ];
    # keyboard.layout = [ "emacs2" ];
  };

  programs.direnv.enable = true;

  programs.man.enable = false;

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (e: [ e.pass-audit e.pass-otp ]);
  };

  programs.bat = {
    enable = true;
    config = { tabs = "8"; };
  };

  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    extraConfig = ''
      set bell-style none
    '';
  };

  xdg = {
    enable = true;
    configHome = "${home_directory}/.config";
    dataHome = "${home_directory}/.local/share";
    cacheHome = "${home_directory}/.cache";
    # xdg.menus.enable = true;  
  };

  xresources.properties = {
    # Set some Emacs GUI properties in the .Xresources file because
    # they are expensive to set during initialization in Emacs lisp.
    # This saves about half a second on startup time. See the
    # following link for more options:
    # https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
    "Emacs.menuBar" = false;
    "Emacs.toolBar" = false;
    "Emacs.verticalScrollBars" = false;
    "Emacs.Font" = "DejaVu Sans Mono:size=18";
    "Xcursor.size" = "96";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = false;
    pinentryFlavor = "tty";
    extraConfig = ''
      allow-loopback-pinentry
      allow-emacs-pinentry
    '';
  };

  home.extraOutputsToInstall = [ "man" ];

  #systemd.user.startServices = true;
  #systemd.user.services.gpg-agent.Install.WantedBy = [ "default.target" ];

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile programs/tmux/tmux.conf;
    plugins = with pkgs; [{
      plugin = tmuxPlugins.sidebar;
      extraConfig = "set -g @sidebar-tree-command 'tree -C'";
    }];
  };

  # services.gnome-keyring = {
  #     enable = true;
  # };

  # services.gnome3 = {
  #     gnome-keyring.enable = true;
  #     seahorse.enable = true;
  # };

  # security.pam.services.lightdm.enableGnomeKeyring = true;

  programs.emacs = {
    enable = true;
    #package = pkgs.emacs-overlay.emacsGit;
    package = pkgs.emacs;
    extraPackages = epkgs: with epkgs; [ melpaStablePackages.emacsql-sqlite emacs-libvterm pdf-tools elisp-ffi exwm ];
  };

  # home.file.".local/share/gnome-shell/extensions/tilingnome@rliang.github.com".source =
  #   builtins.fetchGit { url = "https://github.com/rliang/gnome-shell-extension-tilingnome.git"; };

  # home.file.".local/share/gnome-shell/extensions/dim.desktop.70@d0h0.tuta.io".source =
  #   builtins.fetchGit { url = "https://github.com/d0h0/dim.desktop.gnome.extension.git"; };

  home.file.".local/share/gnome-shell/extensions/dark-mode@lossurdo.com".source =
    builtins.fetchGit { url = "https://github.com/lossurdo/gnome-shell-extension-dark-mode.git"; };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell".enabled-extensions = [
        # "tilingnome@rliang.github.com"
        # "dark-mode@lossurdo.com"
        "dim.desktop.70@d0h0.tuta.io"
      ];
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
        cursor-blink = false;
        cursor-size = 96;
        monospace-font-name = "Source Code Pro Semibold 14";
        text-scaling-factor = 1.25;
        enable-animations = false;
        gtk-key-theme = "Emacs";
      };
      "org/gnome/desktop/wm/preferences" = {
        audible-bell = false;
        visual-bell = false;
      };
      "org/gnome/desktop/input-sources" = { xkb-options = [ "caps:ctrl_modifier" ]; };
    };
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    themeVariant = "default";
    # menuAcceleratorEnabled = false;
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
