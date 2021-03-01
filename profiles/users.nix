{ pkgs, lib, ... }:

let

  inherit (lib) mkIf mkMerge optionalAttrs;
  inherit (builtins) currentSystem;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

  authorizedKeys = import ./authorized-keys.nix;
  homeManager = import ../config/home-manager.nix;

in

mkMerge [
  {
    home-manager.users.aim = homeManager;
    users.users.aim.home = mkIf isDarwin "/Users/aim";
  }

  (optionalAttrs isLinux {
    users.defaultUserShell = pkgs.zsh;

    home-manager.users.root = homeManager;

    # users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
    users.users.aim = {};
  })
]
