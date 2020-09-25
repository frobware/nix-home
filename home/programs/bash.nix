{ config, pkgs, ... }:

{
  home.packages = [ pkgs.bash-completion ];

  programs.bash = {
    enable = true;
    enableAutojump = true;
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

      export PS1="\u@\h:\w\n$ "

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

      function source_kubectl_completion() {
          type -P kubectl 2>&1 >/dev/null && source <(kubectl completion bash)
      }

      function source_oc_completion() {
          type -P oc 2>&1 >/dev/null && source <(oc completion bash)
      }

      function source_ocadm_completion() {
          type -P oc adm 2>&1 >/dev/null && source <(oc adm completion bash)
      }

      source_kubectl_completion
      source_oc_completion
      source_ocadm_completion
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
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/bin:$PATH"
      export PATH="/usr/local/emacs-27/bin:$PATH"
      export PATH="/usr/local/emacs-nativecomp/bin:$PATH"
      # Fixes libvirt issues; https://serverfault.com/questions/803283/how-do-i-list-virsh-networks-without-sudo/803298
      export LIBVIRT_DEFAULT_URI=qemu:///system

      # Make sure we don't import this file multiple times
      #
      export __PROFILE_SOURCED=1

      export $(gnome-keyring-daemon --start)
    '';
    shellAliases = {
      h = "history 20";
      ls = "ls --color=no";
      lst = "ls -trl";
      more = "less";
    };
    shellOptions = [
      "checkwinsize" # Update window lines/columns after each command
      "histappend" # Append to, rather than replacing, history file on exit
      "histreedit" # Allow editing of previously run commands
      "hostcomplete" # Attempt to auto-complete hostnames
    ];
  };
}
