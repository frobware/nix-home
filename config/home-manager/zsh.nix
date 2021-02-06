{ config, pkgs, ... }:

{
  programs.bat.enable = true;
  xdg.enable = true;

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.zsh = rec {
    enable = true;

    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    history.extended = true;

    history = {
      size = 50000;
      save = 5000000;
      path = "${dotDir}/history";
      ignoreDups = true;
      share = true;
    };

    sessionVariables = {
      GOPATH = "$HOME";
      ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
      EDITOR = "emacsclient -t -a vi";
      VISUAL = "emacsclient -c -a vi";
      LC_CTYPE = "en_US.UTF-8";
      LESS = "-FRSXM";
      PROMPT = "$ %m %B%F{240}%4~%f%b\n$ ";
      RPROMPT = "";
      #PASSWORD_STORE_DIR = "${xdg.configHome}/password-store";
    };

    profileExtra = ''
      # export GPG_TTY=$(tty)
      # if ! pgrep -x "gpg-agent" > /dev/null; then
      # ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
      # fi

      setopt extended_glob

      # Bash-like navigation
      autoload -U select-word-style
      select-word-style bash

      setopt autocd autopushd pushdignoredups no_beep
      bindkey -e

      # put completions below the prompt
      unsetopt ALWAYS_LAST_PROMPT

      # HIST_VERIFY
      # Whenever the user enters a line with history expansion, don't
      # execute the line directly; instead, perform history expansion
      # and reload the line into the editing buffer.
      #
      # Allow me to mkdir foo; cd !$
      setopt no_hist_verify

      # if type -p oc >/dev/null 2>&1; then
      #     source <(oc completion zsh)
      # fi
    '';

    initExtra = pkgs.lib.mkBefore ''
      # export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
      # if [[ $TERM == dumb || $TERM == emacs || ! -o interactive ]]; then
      # unsetopt zle
      # unset zle_bracketed_paste
      # export PS1='%m %~ $ '
      # fi
    '';
  };
}
