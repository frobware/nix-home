{ config, lib, pkgs, ... }:

{
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
    new.tags = [ "new" ];
    new.ignore = [ "/.*[.](json|lock|bak)$/" ".git"];
  };

  programs.afew = {
    enable = true;
    extraConfig = ''
      [KillThreadsFilter]
      [ListMailsFilter]
      [ArchiveSentMailsFilter]

      [Filter.0]
      query = from:notifications@github.com
      tags = +github

      [Filter.1]
      query = from:bugzilla@redhat.com
      tags = +bz

      [HeaderMatchingFilter.0]
      header = X-GitHub-Reason
      pattern = (assign|author|comment|mention|push|review_requested|state_change|team_mention)
      tags = +gh;+inbox;+unread

      [MeFilter]
      [InboxFilter]
    '';
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  accounts.email.certificatesFile = "/etc/ssl/certs/ca-bundle.trust.crt";

  accounts.email.accounts."amcdermo@redhat.com" = {
    address = "amcdermo@redhat.com";
    realName = "Andrew McDermott";
    userName = "amcdermo@redhat.com";
    imap.host = "imap.gmail.com";
    smtp.host = "smtp.gmail.com";
    passwordCommand = "pass rhat/app-password/gnus";
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
          PipelineDepth = 5;
        };
      };
    };
    notmuch.enable = true;
    msmtp.enable = true;
  };
}
