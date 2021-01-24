{ config, lib, pkgs, ... }:

{
  xdg.configFile."tmux/tmux.conf".source = ../../dotfiles/tmux.conf;
}
