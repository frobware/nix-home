{ lib, pkgs, ... }:

# taken from https://github.com/ttuegel/nixos-config/blob/master/config/terminfo.nix

let
  inherit (pkgs) runCommand ncurses;

  # Terminfo file for xterm and konsole with 24-bit colors.
  terminfo-xterm-24bit = runCommand "terminfo-xterm-24bit" {} ''
    cat >terminfo-xterm-24bit.src <<EOF
    xterm-24bits|xterm with 24-bit direct color mode,
      use=xterm-256color,
      setb24=\E[48;2;%p1%{65536}%/%d;%p1%{256}%/%{255}%&%d;%p1%{255}%&%dm,
      setf24=\E[38;2;%p1%{65536}%/%d;%p1%{256}%/%{255}%&%d;%p1%{255}%&%dm,
    EOF
    mkdir -p "$HOME/.terminfo"
    ${lib.getBin ncurses}/bin/tic -x -o "$HOME/.terminfo" terminfo-xterm-24bit.src
  '';
in {
  home.packages = [ terminfo-xterm-24bit ncurses ];
}
