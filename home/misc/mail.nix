{ config, lib, pkgs, ... }:

{
  programs.notmuch = {
    enable = false;
    hooks = {
      postNew = "${pkgs.afew}/bin/afew --tag --new -v";
    };
    new.tags = [ "new" ];
    new.ignore = [ "/.*[.](json|lock|bak)$/" ".git"];
  };

  programs.afew = {
    enable = false;
    extraConfig = ''
      [KillThreadsFilter]
      [ListMailsFilter]
      [ArchiveSentMailsFilter]

      [Filter.0]
      query = from:notifications@github.com
      tags = +github

      [MeFilter]

      [Filter.1]
      query = from:bugzilla@redhat.com
      tags = +bz

      [Filter.2]
      query = from:bugzilla@redhat.com and tag:to-me
      tags = +bz-me

      [HeaderMatchingFilter.0]
      header = X-GitHub-Reason
      pattern = (assign|author|comment|mention|push|review_requested|state_change|team_mention)
      tags = +gh;+inbox;+unread

      [InboxFilter]
    '';
  };

  accounts.email.accounts."amcdermo@redhat.com" = {
    address = "amcdermo@redhat.com";
    flavor = "gmail.com";
    lieer = {
      enable = false;
      dropNonExistingLabels = true;
      ignoreTagsLocal = [ "new" ];
      sync = {
        enable = false;
        frequency = "*:0/30";
      };
    };
    msmtp.enable = true;
    notmuch.enable = false;
    passwordCommand = "secret-tool lookup user mail";
    primary = true;
    realName = "Andrew McDermott";
    userName = "amcdermo@redhat.com";
  };

  services = {
    lieer.enable = false;
  };
}
