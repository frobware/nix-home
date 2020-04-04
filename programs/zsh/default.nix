{ config, pkgs, ... }:

{
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
}
