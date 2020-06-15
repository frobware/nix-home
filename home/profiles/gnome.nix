{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.gnome;
in {
  options.profiles.gnome = {
    enable = lib.mkEnableOption "gnome desktop";
  };

  config = mkIf config.profiles.gnome.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/peripherals/mouse".natural-scroll = true;
        "org/gnome/desktop/peripherals/touchpad".natural-scroll = true;

        "org/gnome/desktop/background" = {
          picture-options = "none";
          primary-color = "#606060"; # grey. ish.
        };

        "org/gnome/desktop/interface" = {
          enable-hot-corners = false;
          cursor-blink = false;
          cursor-size = 96;
          monospace-font-name = "Source Code Pro Semibold 14";
          text-scaling-factor = 1.25;
          enable-animations = false;
          gtk-key-theme = "Emacs";
        };

        "org/gnome/desktop/wm/preferences" = {
          audible-bell = false;
          visual-bell = false;
        };

        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "caps:ctrl_modifier" ];
        };

        "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/emacs/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/chrome/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/invert/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/maxvertically/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
        ];

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/emacs" = {
          binding = "<Alt><Shift>e";
          command = "${pkgs.xdwim}/bin/rxdwimctl emacs bash -login -c \'emacsclient -c --alternate-editor=\"\" --frame-parameters=\"((reverse . t))\"\'";
          name = "Emacs";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox" = {
          binding = "<Control><Alt><Shift>f";
          name = "Firefox";
          command  = "bash -c \"${pkgs.wmctrl}/bin/wmctrl -R firefox || (exec firefox &)\"";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/chrome" = {
          binding = "<Control><Alt><Shift>n";
          name = "Chrome";
          command = "${pkgs.xdwim}/bin/rxdwimctl google-chrome google-chrome";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/invert" = {
          binding = "<Control><Alt><Shift>i";
          command = "${pkgs.xcalib}/bin/xcalib -i -a";
          name = "Invert";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/maxvertically" = {
          binding = "<Control><Alt><Shift>v";
          command = "${pkgs.wmctrl}/bin/wmctrl -r :ACTIVE: -b toggle,maximized_vert";
          name = "MaxVertically";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
          binding = "<Alt><Shift>n";
          command = "${pkgs.xdwim}/bin/rxdwimctl Gnome-terminal gnome-terminal";
          name = "Terminal";
        };
      };
    };

    home.packages = [
      pkgs.xdwim
      pkgs.chrome-gnome-shell
      pkgs.gnome3.dconf-editor
      pkgs.gnome3.gnome-tweaks
    ];

    programs.chromium.extensions = [
      "gphhapmejobijbbhgpjhcjognlahblep" # GNOME Shell integration
    ];

    programs.gnome-terminal.enable = true;

    profiles.xdwim.enable = true;

    qt = {
      enable = true;
      platformTheme = "gnome";  # for kdiff3
    };
  };
}
