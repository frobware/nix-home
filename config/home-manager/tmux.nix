{ config, lib, pkgs, ... }:

{
  xdg.configFile."tmux/tmux.conf".source = ./../../home/programs/tmux.conf;
}
