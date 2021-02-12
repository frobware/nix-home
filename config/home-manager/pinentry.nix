{ config, pkgs, ... }:

{
  programs.gpg.enable = true;

  home.file.".gnupg/gpg-agent.conf".text = ''
    enable-ssh-support
    no-grab
    allow-emacs-pinentry
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  '';
}
