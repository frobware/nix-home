{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.xdwim;
  xdwim = pkgs.callPackage ../../pkgs/xdwim {};

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
      Install = {
        WantedBy = [ "multi-user.target" ];
      };
      Service = {
        ExecStart = "${xdwim}/bin/rxdwim";
      };
    };

    # let dconf.settings = let dconfPath = "org/gnome/settings-daemon/plugins/media-keys";
    # in
    # {
    #   "${dconfPath}".custom-keybindings = [
    #     keyMappings
    #   ];
    # };
  };
}
