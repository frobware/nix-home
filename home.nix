{ config, lib, pkgs, ... }:

let
  locale = "en_US.UTF-8";
  home_directory = builtins.getEnv "HOME";
  tmp_directory = "/tmp";
  ca-bundle_crt = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  custom-golist = pkgs.callPackage pkgs/golist { };
in rec {
  programs.home-manager = {
    enable = true;
    path = "./home-manager";
  };

  # imports = [
  #   ./config/terminfo.nix
  # ];
  
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

      # Fonts
      pkgs.dejavu_fonts
      pkgs.fontconfig

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

  programs.bash = {
    enable = true;

    shellAliases = {
      gnome-dark-mode = "gsettings set org.gnome.desktop.interface gtk-theme \${GNOME_DARK_MODE:-Adwaita-dark}";
      gnome-light-mode = "gsettings set org.gnome.desktop.interface gtk-theme  \${GNOME_DARK_MODE:-Adwaita-light}";
      amke = "make";
      cat = "${pkgs.bat}/bin/bat";
      disarm-openshift-ingress-operator = "kubectl scale --replicas=0 -n openshift-ingress-operator deployment ingress-operator";
      disarm-the-cvo = "${pkgs.kubectl}/bin/kubectl scale deployment --replicas=0 -n openshift-cluster-version cluster-version-operator";
      dnf = "dnf --cacheonly";
      dockerclean = "dockercleanc || true && dockercleani";
      dockercleanc = "docker rm $(docker ps -a -q)";
      dockercleandangling = "docker rmi $(docker images -q --filter 'dangling=true')";
      dockercleani = "docker rmi $(docker images -q -f dangling=true)";
      dockerkillall = "docker kill $(docker ps -q)";
      e = "open-here";
      eric-le-cluster = "curl https://raw.githubusercontent.com/eparis/ssh-bastion/master/deploy/deploy.sh | bash";
      gdb = "${pkgs.gdb}/bin/gdb -q";
      h = "history 10";
      kalpine = "${pkgs.kubectl}/bin/kubectl run -it --rm --restart=Never alpine --image=alpine sh";
      kb = "${pkgs.kubectl}/bin/kubectl get build --no-headers --sort-by=.metadata.creationTimestamp";
      kcn = "${pkgs.kubectl}/bin/kubectl config set-context $(kubectl config current-context) --namespace";
      ke = "${pkgs.kubectl}/bin/kubectl get events --no-headers --sort-by=.metadata.creationTimestamp |cat -n";
      km = "${pkgs.kubectl}/bin/kubectl get machines --no-headers --sort-by=.metadata.creationTimestamp |cat -n";
      kn = "${pkgs.kubectl}/bin/kubectl get nodes --no-headers --sort-by=.metadata.creationTimestamp |cat -n";
      ls = "ls --color=no";
      lst = "ls -trl | tail";
      mkae = "make";
      more = "less";
      netshoot = "${pkgs.kubectl}/bin/kubectl run --generator=run-pod/v1 tmp-shell --rm -i --tty --image nicolaka/netshoot -- /bin/bash";
      nowrap = "tput rmam";
      open-here = "emacsclient -t -n .";
      rust-gdb = "rust-gdb -q";
      scale-router = "oc scale deployment/router-default -n openshift-ingress --replicas=${"1:-1"}";
      wrap = "tput smam";
    };

    initExtra = pkgs.lib.mkBefore ''
      source /etc/profile
    '';

    bashrcExtra = pkgs.lib.mkBefore ''
      # [ -n "$DISPLAY" ] && source $HOME/.xprofile

      source /etc/bashrc

      if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
      source ~/.nix-profile/etc/profile.d/nix.sh
      fi

      export GPG_TTY=$(tty)
      if ! pgrep -x "gpg-agent" > /dev/null; then
      ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
      fi

      export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
      export PATH=$HOME/.local/bin:$HOME/bin:$PATH
    '';
  };

  programs.zsh = rec {
    enable = true;

    dotDir = ".config/zsh";
    enableCompletion = false;
    enableAutosuggestions = true;

    defaultKeymap = "emacs";

    # enableFzfCompletion = true;
    # enableFzfGit = true;
    # enableFzfHistory = true;
    # enableSyntaxHighlighting = true;

    history = {
      size = 50000;
      save = 5000000;
      path = "${dotDir}/history";
      ignoreDups = true;
      share = true;
    };

    sessionVariables = {
      ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
      EDITOR = "emacsclient -t -a vi";
      VISUAL = "emacsclient -c -a vi";
      LC_CTYPE = "en_US.UTF-8";
      LESS = "-FRSXM";
      PROMPT = "%m %~ $ ";
      PROMPT_DIRTRIM = "2";
      PASSWORD_STORE_DIR = "${xdg.configHome}/password-store";
    };

    profileExtra = ''
      export GPG_TTY=$(tty)
      if ! pgrep -x "gpg-agent" > /dev/null; then
      ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
      fi

      setopt extended_glob

      # Bash-like navigation
      autoload -U select-word-style
      select-word-style bash

      setopt autocd autopushd pushdignoredups no_beep
      bindkey -e
    '';

    initExtra = pkgs.lib.mkBefore ''
      export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
      if [[ $TERM == dumb || $TERM == emacs || ! -o interactive ]]; then
      unsetopt zle
      unset zle_bracketed_paste
      export PS1='%m %~ $ '
      fi
    '';
  };

  xdg = {
    enable = true;
    configHome = "${home_directory}/.config";
    dataHome = "${home_directory}/.local/share";
    cacheHome = "${home_directory}/.cache";
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

  home.file.".xprofile".text = ''
    xset b off
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap us -option ctrl:nocaps
    XPROFILED=1
    export XPROFILED
  '';

  # home.file.".local/share/gnome-shell/extensions/tilingnome@rliang.github.com".source =
  #   builtins.fetchGit { url = "https://github.com/rliang/gnome-shell-extension-tilingnome.git"; };

  # home.file.".local/share/gnome-shell/extensions/dark-mode@lossurdo.github.com".source =
  #   builtins.fetchGit { url = "https://github.com/lossurdo/gnome-shell-extension-dark-mode.git"; };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell".enabled-extensions = [
        "tilingnome@rliang.github.com"
        "dark-mode@lossurdo.github.com"
      ];
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
        cursor-blink = false;
        cursor-size = 96;
        # font-name = "DejaVu Sans 14";
        monospace-font-name = "Source Code Pro 14";
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

  home.file.".local/share/themes/custom/gnome-shell".text = ''
    @import url("resource:///org/gnome/theme/gnome-shell.css");
    stage {
      font-size: 24pt;
    }
  '';

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
