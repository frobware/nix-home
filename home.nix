{ config, lib, pkgs, ... }:

let
  locale = "en_US.UTF-8";
  home_directory = builtins.getEnv "HOME";
  tmp_directory = "/tmp";
  ca-bundle_crt = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  xdwim = pkgs.callPackage pkgs/xdwim {};
in rec {
  targets.genericLinux.enable = true;

  imports = [
    ./config/git.nix
    ./programs/bash
    ./modules/programs/xdwim.nix
  ];

  fonts.fontconfig.enable = false;

  programs.home-manager = {
    enable = true;
    path = "./home-manager";
  };

  services.xdwim = {
    enable = true;
    keyMappings = [
      {
        name = "foo";
        shortcut = "<Control>A";
        command = "emacs";
      }
      {
        name = "baz";
        shortcut = "<Control>B";
        command = "vim";
      }
    ];
  };

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
      (pkgs.callPackage ./scripts/switch-to-firefox.nix {})
      (pkgs.callPackage ./scripts/gnome-toggle-theme.nix {})

      # Mail
      pkgs.afew
      pkgs.alot
      pkgs.imapsync
      pkgs.isync
      pkgs.notmuch
      pkgs.dovecot
      pkgs.msmtp

      # Clouds
      pkgs.awscli
      pkgs.google-cloud-sdk
      pkgs.azure-cli
      pkgs.doctl

      # Nix
      pkgs.nox
      pkgs.niv
      pkgs.nixfmt
      pkgs.nix-info

      # Straight
      pkgs.watchexec

      # Browsers
      # pkgs.google-chrome
      # pkgs.firefox

      # Development tools
      pkgs.gnumake
      pkgs.strace
      pkgs.yaml-language-server
      pkgs.cmake
      pkgs.shellcheck

      # Utilities
      pkgs.ag
      pkgs.gnupg
      pkgs.htop
      pkgs.ripgrep
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

      # Rust
      pkgs.rust-analyzer
      pkgs.clippy
      pkgs.rls
      pkgs.cargo

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
      pkgs.gotools
      pkgs.gopls
      pkgs.gotop

      # X11
      pkgs.wmctrl
      pkgs.xclip
      pkgs.xsel

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
      EDITOR = "/usr/local/emacs-27/bin/emacsclient -t -a vi";
      VISUAL = "/usr/local/emacs-27/bin/emacsclient -c -a vi";
      LESSHISTFILE = "${xdg.cacheHome}/less/history";
      LOCATE_PATH = "${xdg.cacheHome}/locate/home.db:${xdg.cacheHome}/locate/system.db";
      PASSWORD_STORE_DIR = "${xdg.configHome}/password-store";

      # https://github.com/NixOS/nixpkgs/issues/58132
      GIT_SSH = "/usr/bin/ssh";
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
      set completion-ignore-case on
      # single Tab will complete if unique, display multiple
      # completions otherwise
      set show-all-if-ambiguous on
      # use up and down arrow to match search history based on typed
      # starting text.
      "\e[A": history-search-backward
      "\e[B": history-search-forward
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

  # programs.emacs = {
  #   enable = true;
  #   #package = pkgs.emacs-overlay.emacsGit;
  #   package = pkgs.emacs;
  #   extraPackages = epkgs: with epkgs; [ melpaStablePackages.emacsql-sqlite emacs-libvterm pdf-tools elisp-ffi exwm ];
  # };

  dconf = {
    enable = true;
    settings = {
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

      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/emacs/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/chrome/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/invert/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/maxvertically/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
      ];

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/emacs" = {
        binding = "<Alt><Shift>e";
        command = "${xdwim}/bin/rxdwimctl emacs bash -login -c \'/usr/local/emacs-27/bin/emacsclient -c --alternate-editor=\"\" --frame-parameters=\"((reverse . t))\"\'";
        name = "Emacs";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox" = {
        binding = "<Control><Alt><Shift>f";
        name = "Firefox";
        command  = "bash -c \"${pkgs.wmctrl}/bin/wmctrl -R firefox || (exec firefox &)\"";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/chrome" = {
        binding = "<Control><Alt><Shift>n";
        name = "Chrome";
        command = "${xdwim}/bin/rxdwimctl google-chrome google-chrome";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/invert" = {
        binding = "<Control><Alt><Shift>i";
        command = "${pkgs.xcalib}/bin/xcalib -i -a";
        name = "Invert";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/maxvertically" = {
        binding = "<Control><Alt><Shift>v";
        command = "${pkgs.wmctrl}/bin/wmctrl -r :ACTIVE: -b toggle,maximized_vert";
        name = "MaxVertically";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
        binding = "<Alt><Shift>n";
        command = "${xdwim}/bin/rxdwimctl Gnome-terminal gnome-terminal";
        name = "Terminal";
      };
    };
  };

  programs.gnome-terminal = {
    enable = true;
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

  systemd.user.services.languagetool-http-server = {
    Unit = {
      Description = "languagetool-http-server";
    };

    Service = {
      ExecStart = "${pkgs.languagetool}/bin/languagetool-http-server";
      ExecReload = "${pkgs.languagetool}/bin/languagetool-http-server";
      Restart = "always";
      RestartSec = 12;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # services.kbfs.enable = false;
  # services.keybase.enable = false;

  systemd.user.startServices = true;
}
