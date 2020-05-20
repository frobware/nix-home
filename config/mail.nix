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

  accounts.email.accounts."andrew.iain.mcdermott@gmail.com" = {
    address = "andrew.iain.mcdermott@gmail.com";
    flavor = "gmail.com";
    lieer = {
      enable = true;
      dropNonExistingLabels = true;
      sync.enable = true;
    };
    msmtp.enable = true;
    notmuch.enable = true;
    passwordCommand = "secret-tool lookup user mail";
    primary = true;
    realName = "Andrew McDermott";
    userName = "andrew.iain.mcdermott@gmail.com";
  };

  services = {
    lieer.enable = true;
  };
}
