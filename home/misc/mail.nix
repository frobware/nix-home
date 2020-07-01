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
    extraConfig = ''
      [KillThreadsFilter]
      [ListMailsFilter]
      [ArchiveSentMailsFilter]
      [InboxFilter]
    '';
  };

  accounts.email.accounts."amcdermo@redhat.com" = {
    address = "amcdermo@redhat.com";
    flavor = "gmail.com";
    lieer = {
      enable = true;
      dropNonExistingLabels = true;
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
