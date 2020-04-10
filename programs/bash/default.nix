{ config, pkgs, ... }:

{
  home.packages = [ pkgs.bash-completion ];

  programs.bash = {
    enable = true;
    historyFileSize = 2000;
    historySize = 1000;
    initExtra = ''
      # Source .profile, if not already done
      #
      if [[ -z "$__PROFILE_SOURCED" ]] && [[ -f "$HOME/.profile" ]]; then
        source "$HOME/.profile"
      fi

      # Nicer colors in `ls`
      #
      eval "$(dircolors --sh)"

      # BASH completion; test is cribbed from the Debian 9 skel.
      #
      if [[ ! $(shopt -oq posix) ]]; then
        source "${config.home.profileDirectory}/etc/profile.d/bash_completion.sh"
      fi

      # Use up- and down-arrows to search through history like ZSH.
      #
      # NOTE that the only way to reliably assign the arrow keys appears
      # to be to insert them literally (Ctrl+V in ViM, Meta+V in Nano,
      # then press the up (for `history-search-backward`) or down (for
      # `history-search-forward) arrow key.
      #
      bind '"[A":history-search-backward'
      bind '"[B":history-search-forward'

      # Prompt, largely cribbed from BASH-IT's "pure" prompt, with bits
      # from the Debian 9 skel.
      #
      if [[ $(id -u) -eq 0 ]]; then
        export PS1="\[\e[0;31m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]:\[\e[0;33m\]\w\[\e[0m\] \[\e[0;31m\]\$\[\e[39m\] "
      else
        export PS1="\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;34m\]\h\[\e[0m\]:\[\e[0;33m\]\w\[\e[0m\] \[\e[0;32m\]\$\[\e[39m\] "
      fi

      # If running under something that claims to act like XTerm, try to
      # dynamically set the window title.
      #
      if [[ "$TERM" =~ xterm.* ]] || [[ -n "$TMUX" ]]; then
        function refresh_window_title {
          if [[ "$PWD" == "$HOME" ]]; then
            WIN_TITLE_DIR="~"
          else
            WIN_TITLE_DIR="${"\${PWD/#$HOME\\\//\\\~\\\/}"}"
          fi
          echo -ne "\033]0;$USER@$HOSTNAME:$WIN_TITLE_DIR\007"
        }
        if [[ $(echo "$PROMPT_COMMAND" | grep -c "refresh_window_title") -eq 0 ]]; then
          export PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND ; }refresh_window_title"
        fi
      fi

      # Source .config/profile.d/*, if the directory exists
      #
      if [[ -d "${config.xdg.configHome}/profile.d" ]]; then
        while IFS=$'\0' read -d $'\0' -r FILE; do
          source "$FILE"
        done < <(find "${config.xdg.configHome}/profile.d" -name '*.sh' -print0)
      fi
    '';
    logoutExtra = ''
      # When leaving the console clear the screen to increase privacy.
      #
      # Cribbed from the Debian 9 skel.
      #
      if [[ "$SHLVL" == "1" ]]; then
        clear
      fi
    '';
    profileExtra = ''
      # Explicitly set the default umask. This is particularly important
      # on the Windows Linux Subsystem, which uses the brain-dead umask
      # of 0000.
      #
      umask 027

      # Setup Nix environment, if applicable
      #
      if [ -f "${config.home.profileDirectory}/etc/profile.d/nix.sh" ]; then
        . "${config.home.profileDirectory}/etc/profile.d/nix.sh"
      fi

      # Add script/wrapper directories to PATH
      #
      export PATH="${config.home.profileDirectory}/scripts:$PATH"
      export PATH="${config.home.profileDirectory}/wrappers:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/bin:$PATH"

      # Make sure we don't import this file multiple times
      #
      export __PROFILE_SOURCED=1
    '';
    shellAliases = {
      ls = "${pkgs.coreutils}/bin/ls --color=auto";
      la = "${pkgs.coreutils}/bin/ls --color=auto --all";
      lh = "${pkgs.coreutils}/bin/ls --color=auto --long --human-readable";
      ll = "${pkgs.coreutils}/bin/ls --color=auto --long";

      gnome-dark-mode = "gsettings set org.gnome.desktop.interface gtk-theme \${GNOME_DARK_MODE:-Adwaita-dark}";
      gnome-light-mode = "gsettings set org.gnome.desktop.interface gtk-theme  \${GNOME_DARK_MODE:-Adwaita-light}";
    };
    shellOptions = [
      "checkwinsize" # Update window lines/columns after each command
      "histappend" # Append to, rather than replacing, history file on exit
      "histreedit" # Allow editing of previously run commands
      "hostcomplete" # Attempt to auto-complete hostnames
    ];
  };

  home.file.".inputrc".text = ''
    set show-all-if-ambiguous on
    set completion-ignore-case on
  '';

  xdg.configFile = {
    "base16-shell" = {
      source = pkgs.fetchFromGitHub {
        owner = "chriskempson";
        repo = "base16-shell";
        rev = "ce8e1e5";
        sha256 = "1yj36k64zz65lxh28bb5rb5skwlinixxz6qwkwaf845ajvm45j1q";
      };
      recursive = true;
    };
    "profile.d/base16.sh".text = ''
      # Initialize terminal colors
      #
      if [[ -n "$PS1" ]] && [[ "$TERM" != "linux" ]] && [[ -s "$BASE16_SHELL/profile_helper.sh" ]]; then
        export BASE16_THEME=solarized-light
        source "${config.xdg.configHome}/base16-shell/scripts/base16-solarized-light.sh"
      fi
    '';
  };
}
