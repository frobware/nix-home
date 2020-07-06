{ config, lib, pkgs, ... }:

{
  programs.notmuch = {
    enable = true;
    hooks = {
      postNew = "${pkgs.afew}/bin/afew --tag --new -v";
    };
    new.tags = [ "new" ];
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

      [HeaderMatchingFilter.0]
      header = X-GitHub-Reason
      pattern = (assign|author|comment|mention|push|review_requested|state_change|team_mention)
      tags = +gh;+inbox;+unread

      [MeFilter]
      [InboxFilter]
    '';
  };

  accounts.email.accounts."amcdermo@redhat.com" = {
    address = "amcdermo@redhat.com";
    flavor = "gmail.com";
    lieer = {
      enable = true;
      dropNonExistingLabels = true;
      ignoreTagsLocal = [ "new" ];
      sync = {
        enable = true;
        frequency = "*:0/30";
      };
    };
    msmtp.enable = true;
    notmuch.enable = true;
    passwordCommand = "secret-tool lookup user mail";
    primary = true;
    realName = "Andrew McDermott";
    userName = "amcdermo@redhat.com";
  };

  services = {
    lieer.enable = true;
  };
}
