{ lib, pkgs, pkgs-unstable, ... }:

let

  inherit (lib) optional optionalAttrs mkIf mkMerge mkDefault flatten;
  inherit (builtins) currentSystem;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

in

{
  imports = flatten [
    (optional isLinux ./hosts.nix)
    (optional isLinux ./../config/ssh.nix)
    ./users.nix
  ];

  users.nix.configureBuildUsers = true;

  environment.pathsToLink = [ "/share/zsh" ];

  # programs.zsh = {
  #   enable = true;

  #   # Prevent NixOS from clobbering prompts
  #   # See: https://github.com/NixOS/nixpkgs/pull/38535
  #   promptInit = lib.mkDefault "";
  # };

} //

mkMerge [
  {
    environment.systemPackages =
      (with pkgs; [
        ag
        bat
        curl
        jq
        less
        mercurial
        mosh
        pass
        tmux
        vim
        watch
        wget
        yq
        socat

        # Mail
        lieer
        notmuch
        isync
        dovecot
      ])

      ++

      (with pkgs.gitAndTools; [
        gh
        git
        git-crypt
        git-fame
        git-hub
        hub
        lab
      ]);
  }

  (optionalAttrs isLinux {
    environment.systemPackages = with pkgs; [
      whois
    ];

    services.ntp.enable = true;

    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };

    system.stateVersion = "20.09";
  })

  (optionalAttrs isDarwin {
    environment.systemPackages = with pkgs; [
      bash
      coreutils
      moreutils
      htop
      gnutar                    # required for kube development
      gnugrep
      tshark
    ];

    system.stateVersion = 4;
  })
]
