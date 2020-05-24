{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.xdwim;
in {
  options.profiles.xdwim = {
    enable = lib.mkEnableOption "xdwim hotkey manager";
  };

  config = mkIf config.profiles.xdwim.enable {
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

    home.packages = [ pkgs.xdwim ];
  };
}
