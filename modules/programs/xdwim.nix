{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.xdwim;
  xdwim = pkgs.callPackage ../../pkgs/xdwim {};
in {
  options.services.xdwim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the xdwim hotkey service.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.xdwim = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${xdwim}/bin/rxdwim";
      };
    };
  };
}
