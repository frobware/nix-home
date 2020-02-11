{ pkgs ? import <nixpkgs> { }, ... }:

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

      # Fonts
      pkgs.dejavu_fonts
      pkgs.fontconfig

      # Grep
      pkgs.ag
      pkgs.gnupg
      pkgs.ripgrep
      pkgs.zlib

      # Spolling!
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

      #pkgs.emacs
    ];

    sessionVariables = {
      ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
      EDITOR = "emacsclient -t -a vi";
      VISUAL = "emacsclient -c -a vi";
      LESSHISTFILE = "${xdg.cacheHome}/less/history";
      LOCATE_PATH = "${xdg.cacheHome}/locate/home.db:${xdg.cacheHome}/locate/system.db";
      PASSWORD_STORE_DIR = "${xdg.configHome}/password-store";
    };

    keyboard.options = [ "caps:ctrl_modifier" ];
    keyboard.layout = [ "emacs2" ];
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

  programs.bash = {
    enable = true;

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
    };
    
    initExtra = pkgs.lib.mkBefore ''
      source /etc/profile
    '';

    bashrcExtra = pkgs.lib.mkBefore ''
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

  # fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans 18";
      package = pkgs.dejavu_fonts;
    };
    iconTheme = { name = "Adwaita-dark"; };
    theme = { name = "Adwaita-dark"; };
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
    "Xcursor.size" = "128";
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

  systemd.user.startServices = true;

  systemd.user.services.gpg-agent.Install.WantedBy = [ "default.target" ];

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
    package = pkgs.emacs-overlay.emacsGit;
    extraPackages = epkgs: with epkgs; [ melpaStablePackages.emacsql-sqlite emacs-libvterm mozc pdf-tools elisp-ffi exwm ];
  };
}
