{ config, lib, pkgs, ... }:

{
  xdg.configFile."tmux/tmux.conf".source = ../../home/programs/tmux.conf;

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../../home/programs/tmux.conf;
    plugins = with pkgs; [{
      plugin = tmuxPlugins.sidebar;
      extraConfig = "set -g @sidebar-tree-command 'tree -C'";
    }];
  };
}
