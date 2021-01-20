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

  home-manager.useUserPackages = true;

  home-manager.users.amcdermo = { pkgs, ... }: {
    programs.direnv.enable = true;
    programs.autojump.enable = true;

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      oh-my-zsh.enable = true;

      dotDir = ".config/zsh";

      defaultKeymap = "emacs";

      # enableFzfCompletion = true;
      # enableFzfGit = true;
      # enableFzfHistory = true;
      # enableSyntaxHighlighting = true;

      history = {
        size = 50000;
        save = 5000000;
        #path = "zhistory";
        ignoreDups = true;
        share = true;
      };

      sessionVariables = {
        ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
        EDITOR = "emacsclient -t -a vi";
        VISUAL = "emacsclient -c -a vi";
        LC_CTYPE = "en_US.UTF-8";
        LESS = "-FRSXM";
        #PROMPT="%m %~ $ ";
        PROMPT="%m $ ";
        PROMPT_DIRTRIM = "2";
        #     PASSWORD_STORE_DIR = "${xdg.configHome}/password-store";
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
        #export PS1="%m %~'\n'$ "
        fi
      '';

      # plugins = [
      #   {
      #     name = "pi-theme";
      #     file = "pi.zsh-theme";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "tobyjamesthomas";
      #       repo = "pi";
      #       rev = "96778f903b79212ac87f706cfc345dd07ea8dc85";
      #       sha256 = "0zjj1pihql5cydj1fiyjlm3163s9zdc63rzypkzmidv88c2kjr1z";
      #     };
      #   }
      # ];
    };
  };
}
