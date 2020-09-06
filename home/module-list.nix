[
  misc/mail.nix
  misc/gnus.nix
  misc/emacs-snippets.nix
  misc/xdg.nix

  profiles/gnome.nix
  profiles/xdwim.nix
  
  programs/bash.nix
  programs/chromium.nix
  programs/firefox.nix
  programs/git.nix
  programs/gnome-terminal.nix
  programs/tmux.nix
  programs/xdwim.nix
  programs/zsh.nix

] ++ (if builtins.pathExists ../local.nix then [
  ../local.nix
] else [])
