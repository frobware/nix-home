{ config, lib, pkgs, ... }:

{
  xdg.configFile."tmux/tmux.conf".source = ../../dotfiles/tmux.conf;

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../../dotfiles/tmux.conf;
    plugins = with pkgs; [{
      plugin = tmuxPlugins.sidebar;
      extraConfig = "set -g @sidebar-tree-command 'tree -C'";
    }];
  };
}
