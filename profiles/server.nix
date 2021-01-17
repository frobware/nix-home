{ config, pkgs, ... }:

{
  imports = [
    ../config/ssh.nix
  ];

  environment.systemPackages = with pkgs; [
    #vim
  ];

  boot.cleanTmpDir = true;

  networking.firewall.allowPing = true;

  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  (optionalAttrs isLinux {
    environment.systemPackages = with pkgs; [
      whois
    ];

    networking.wireguard.enable = true;
  });
}
