{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.zzzdwim;
  xdwim = pkgs.callPackage ../../pkgs/xdwim {};
in {
  options.services.zzzdwim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the xdwim hotkey service.
      '';
    };

    package = mkOption {
      description = "unclutter derivation to use.";
      type = types.package;
      default = pkgs.unclutter-xfixes;
      defaultText = literalExample "pkgs.unclutter-xfixes";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.zzzdwim = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${xdwim}/bin/rxdwim";
      };
    };
  };
}
