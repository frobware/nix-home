{ config, lib, pkgs, ... }:

{
  programs.notmuch = {
    enable = true;
    # hooks = {
    #   preNew = "mbsync --all";
    # };
    new.tags = [ "new" ];
    new.ignore = [ "/.*[.](json|lock|bak)$/" ".git" "dovecot-uidlist" "dovecot-uidvalidity" "subscriptions" ];
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  accounts.email.accounts."amcdermo@redhat.com" = {
    address = "amcdermo@redhat.com";
    realName = "Andrew McDermott";
    userName = "amcdermo@redhat.com";
    imap.host = "imap.gmail.com";
    smtp.host = "smtp.gmail.com";
    passwordCommand = "${pkgs.pass}/bin/pass rhat/app-password/gnus";
    primary = true;
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      patterns = [ "*" "![Gmail]*" "![Gmail]/Sent Mail" "![Gmail]/Starred" "![Gmail]/All Mail" ];
      extraConfig = {
        channel = {
          Sync = "All";
        };
        account = {
          Timeout = 120;
          PipelineDepth = 50;
        };
      };
    };
    notmuch.enable = true;
    msmtp.enable = true;
  };

  services.mbsync.enable = true;
  services.mbsync.frequency = "*:0/30";
}
