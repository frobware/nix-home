{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.xdwim;

  keyMapping = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
      };

      shortcut = mkOption {
        type = types.str;
      };

      command = mkOption {
        type = types.str;
      };
    };
  };

in {
  options.services.xdwim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the xdwim hotkey service.
      '';
    };

    keyMappings = mkOption {
      type = types.loaOf keyMapping;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.xdwim = {
      Unit = {
        Description = "xdwim service";
        PartOf = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${pkgs.xdwim}/bin/rxdwim";
        Restart = "on-abort";
      };

      Install = { WantedBy = [ "graphical-session-pre.target" ]; };
    };
  };
}
