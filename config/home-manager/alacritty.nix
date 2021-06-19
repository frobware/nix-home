{ config, lib, pkgs, ... }:

let

  inherit (lib) flatten optionals;
  inherit (pkgs.stdenv) isDarwin isLinux;

in

{
  # For remapping Alacritty bindings you can see what Alacritty receives
  # by running alacritty --print-events | grep "WindowEvent.*KeyboardInput".
  programs.alacritty = {
    enable = true;
    settings = {
      # shell = {
      #   program = "tmux";
      #   args = [
      #     "new-session"
      #     "-A"
      #     "-s"
      #     "main"
      #   ];
      # };

      # Window decorations
      #
      # Values for `decorations`:
      #     - full: Borders and title bar
      #     - none: Neither borders nor title bar
      #
      # Values for `decorations` (macOS only):
      #     - transparent: Title bar, transparent background and title bar buttons
      #     - buttonless: Title bar, transparent background, but no title bar buttons
      decorations = "full";

      env = {
        TERM = "alacritty-direct";
      };

      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };

        padding = {
          x = 5;
          y = 5;
        };

        class = "Alacritty";
        dynamic_padding = true;
        startup_mode = "Maximized";
        title = "Terminal";
      };

      mouse = {
        # Click settings
        #
        # The `double_click` and `triple_click` settings control the time
        # alacritty should wait for accepting multiple clicks as one double
        # or triple click.
        double_click = { threshold = 300; };
        triple_click = { threshold = 300; };

        # If this is `true`, the cursor is temporarily hidden when typing.
        hide_when_typing = true;

        # Mouse bindings
        #
        # Mouse bindings are specified as a list of objects, much like the key
        # bindings further below.
        #
        # Each mouse binding will specify a:
        #
        # - `mouse`:
        #
        #   - Middle
        #   - Left
        #   - Right
        #   - Numeric identifier such as `5`
        #
        # - `action` (see key bindings)
        #
        # And optionally:
        #
        # - `mods` (see key bindings)
        mouse_bindings = [
          { mouse = "Middle"; action = "PasteSelection"; }
        ];

        hints = {
          # URL launcher
          #
          # This program is executed when clicking on a text which is
          # recognized as a URL. The URL is always added to the
          # command as the last parameter.
          #
          # When set to `None`, URL launching will be disabled
          # completely.
          #
          # Default:
          #   - (macOS) open
          #   - (Linux) xdg-open
          #   - (Windows) explorer
          #launcher = {
          #  program = "xdg-open";
          #  args = [];
          #};

          # URL modifiers
          #
          # These are the modifiers that need to be held down for
          # opening URLs when clicking on them. The available
          # modifiers are documented in the key binding section.
          modifiers = "Shift";
        };
      };

      scrolling = {
        auto_scroll = false;
        faux_multiplier = 3;
        history = 10000;
        multiplier = 3;
      };

      tabspaces = 8;

      # Font configuration (changes require restart)
      font = {
        # normal = {
        #   family = "Menlo";
        # };

        # bold = {
        #   family = "Menlo";
        #   style = "Bold";
        # };

        # italic = {
        #   family = "Menlo";
        #   style = "Regular Italic";
        # };

        # Point size
        size = if isDarwin then 20.0 else 20.0;

        offset = {
          x = 0;
          y = 0;
        };

        glyph_offset = {
          x = 0;
          y = 0;
        };

        use_thin_strokes = false;
      };

      # If `true`, bold text is drawn using the bright color variants.
      draw_bold_text_with_bright_colors = true;

      colors = {
        primary = {
          background = "0x1d1f21";
          foreground = "0xffffff";
          # bright_background = "0x1b1b1b";
        };

        normal = {
          black = "0x2e3436";
          red = "0xcc0000";
          green = "0x4e9a06";
          yellow = "0xc4a000";
          blue = "0x3465a4";
          magenta = "0x75507b";
          cyan = "0x06989a";
          white = "0xd3d7cf";
        };

        bright = {
          black = "0x555753";
          red = "0xef2929";
          green = "0x8ae234";
          yellow = "0xfce94f";
          blue = "0x729fcf";
          magenta = "0xad7fa8";
          cyan = "0x34e2e2";
          white = "0xeeeeec";
        };

        indexed_colors = [];
      };

      background_opacity = 1.0;

      selection = {
        save_to_clipboard = true;
      };

      dynamic_title = true;

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      live_config_reload = true;
      enable_experimental_conpty_backend = false;
      alt_send_esc = true;

      key_bindings = flatten [
        # Linux only
        (optionals isLinux [
          { key = "V";        mods = "Control|Shift";   action = "Paste";             }
          { key = "C";        mods = "Control|Shift";   action = "Copy";              }
          { key = "Insert";   mods = "Shift";           action = "PasteSelection";    }
          { key = "Key0";     mods = "Control";         action = "ResetFontSize";     }
          { key = "Equals";   mods = "Control";         action = "IncreaseFontSize";  }
          { key = "Plus";     mods = "Control";         action = "IncreaseFontSize";  }
          { key = "Subtract"; mods = "Control";         action = "DecreaseFontSize";  }
          { key = "Minus";    mods = "Control";         action = "DecreaseFontSize";  }
          { key = "Return";   mods = "Alt";             action = "ToggleFullScreen";  }
        ])

        # (macOS only)
        (optionals isDarwin [
          #{ key = "Key0";     mods = "Alt";         action = "ResetFontSize";     }
          #{ key = "Equals";   mods = "Alt";         action = "IncreaseFontSize";  }
          #{ key = "Plus";      mods = "Alt";         action = "IncreaseFontSize";  }
          #{ key = "Minus";    mods = "Alt";         action = "DecreaseFontSize";  }
          #{ key = "K";        mods = "Alt";         action = "ClearHistory";      }
          #{ key = "K";        mods = "Alt";         chars = "\\x0c";              }
          #{ key = "V";        mods = "Alt";         action = "Paste";             }
          #{ key = "C";        mods = "Alt";         action = "Copy";              }
          #{ key = "H";        mods = "Alt";         action = "Hide";              }
          #{ key = "Q";        mods = "Alt";         action = "Quit";              }
          #{ key = "W";        mods = "Alt";         action = "Quit";              }
          #{ key = "F";        mods = "Alt|Control"; action = "ToggleFullScreen";  }

          { key = "C";        mods = "Alt";         action = "None";              }
          { key = "Equals";   mods = "Alt";         action = "None";              }
          { key = "F";        mods = "Alt|Control"; action = "None";              }
          { key = "H";        mods = "Alt";         action = "None";              }
          { key = "K";        mods = "Alt";         action = "None";              }
          { key = "K";        mods = "Alt";         action = "None";              }
          { key = "Key0";     mods = "Alt";         action = "None";              }
          { key = "Minus";    mods = "Alt";         action = "None";              }
          { key = "N";        mods = "Alt";         action = "None";              }
          { key = "Plus";     mods = "Alt";         action = "None";              }
          { key = "Q";        mods = "Alt";         action = "None";              }
          { key = "V";        mods = "Alt";         action = "None";              }
          { key = "W";        mods = "Alt";         action = "None";              }

          { key = "C"; mods = "Control|Shift"; action = "Copy"; }
          { key = "V"; mods = "Control|Shift"; action = "Paste"; }

          { key = "Insert";   mods = "Shift";           action = "PasteSelection";    }
          { key = "Key0";     mods = "Control";         action = "ResetFontSize";     }
          { key = "Equals";   mods = "Control|Shift";   action = "IncreaseFontSize";  }
          { key = "Minus";    mods = "Control";         action = "DecreaseFontSize";  }
          { key = "Return";   mods = "Alt|Control";             action = "ToggleFullScreen";  }

          { key = "Grave";    mods = "Alt";         chars = "\\x1b`"; } # Alt + `
          { key = "Grave";    mods = "Alt|Shift";   chars = "\\x1b~"; } # Alt + `

          { key = "N"; mods = "Command|Shift"; action = "SpawnNewInstance"; }

          # A-Z

          { key = "A";         mods = "Alt";       chars = "\\x1ba"; }
          { key = "B";         mods = "Alt";       chars = "\\x1bb"; }
          { key = "C";         mods = "Alt";       chars = "\\x1bc"; }
          { key = "D";         mods = "Alt";       chars = "\\x1bd"; }
          { key = "E";         mods = "Alt";       chars = "\\x1be"; }
          { key = "F";         mods = "Alt";       chars = "\\x1bf"; }
          { key = "G";         mods = "Alt";       chars = "\\x1bg"; }
          { key = "H";         mods = "Alt";       chars = "\\x1bh"; }
          { key = "I";         mods = "Alt";       chars = "\\x1bi"; }
          { key = "J";         mods = "Alt";       chars = "\\x1bj"; }
          { key = "K";         mods = "Alt";       chars = "\\x1bk"; }
          { key = "L";         mods = "Alt";       chars = "\\x1bl"; }
          { key = "M";         mods = "Alt";       chars = "\\x1bm"; }
          { key = "N";         mods = "Alt";       chars = "\\x1bn"; }
          { key = "O";         mods = "Alt";       chars = "\\x1bo"; }
          { key = "P";         mods = "Alt";       chars = "\\x1bp"; }
          { key = "Q";         mods = "Alt";       chars = "\\x1bq"; }
          { key = "R";         mods = "Alt";       chars = "\\x1br"; }
          { key = "S";         mods = "Alt";       chars = "\\x1bs"; }
          { key = "T";         mods = "Alt";       chars = "\\x1bt"; }
          { key = "U";         mods = "Alt";       chars = "\\x1bu"; }
          { key = "V";         mods = "Alt";       chars = "\\x1bv"; }
          { key = "W";         mods = "Alt";       chars = "\\x1bw"; }
          { key = "X";         mods = "Alt";       chars = "\\x1bx"; }
          { key = "Y";         mods = "Alt";       chars = "\\x1by"; }
          { key = "Z";         mods = "Alt";       chars = "\\x1bz"; }
          { key = "A";         mods = "Alt|Shift"; chars = "\\x1bA"; }
          { key = "B";         mods = "Alt|Shift"; chars = "\\x1bB"; }
          { key = "C";         mods = "Alt|Shift"; chars = "\\x1bC"; }
          { key = "D";         mods = "Alt|Shift"; chars = "\\x1bD"; }
          { key = "E";         mods = "Alt|Shift"; chars = "\\x1bE"; }
          { key = "F";         mods = "Alt|Shift"; chars = "\\x1bF"; }
          { key = "G";         mods = "Alt|Shift"; chars = "\\x1bG"; }
          { key = "H";         mods = "Alt|Shift"; chars = "\\x1bH"; }
          { key = "I";         mods = "Alt|Shift"; chars = "\\x1bI"; }
          { key = "J";         mods = "Alt|Shift"; chars = "\\x1bJ"; }
          { key = "K";         mods = "Alt|Shift"; chars = "\\x1bK"; }
          { key = "L";         mods = "Alt|Shift"; chars = "\\x1bL"; }
          { key = "M";         mods = "Alt|Shift"; chars = "\\x1bM"; }
          { key = "N";         mods = "Alt|Shift"; chars = "\\x1bN"; }
          { key = "O";         mods = "Alt|Shift"; chars = "\\x1bO"; }
          { key = "P";         mods = "Alt|Shift"; chars = "\\x1bP"; }
          { key = "Q";         mods = "Alt|Shift"; chars = "\\x1bQ"; }
          { key = "R";         mods = "Alt|Shift"; chars = "\\x1bR"; }
          { key = "S";         mods = "Alt|Shift"; chars = "\\x1bS"; }
          { key = "T";         mods = "Alt|Shift"; chars = "\\x1bT"; }
          { key = "U";         mods = "Alt|Shift"; chars = "\\x1bU"; }
          { key = "V";         mods = "Alt|Shift"; chars = "\\x1bV"; }
          { key = "W";         mods = "Alt|Shift"; chars = "\\x1bW"; }
          { key = "X";         mods = "Alt|Shift"; chars = "\\x1bX"; }
          { key = "Y";         mods = "Alt|Shift"; chars = "\\x1bY"; }
          { key = "Z";         mods = "Alt|Shift"; chars = "\\x1bZ"; }

          { key = "Semicolon"; mods = "Alt"; chars = "\\x1b;"; }
          { key = "Semicolon"; mods = "Alt|Shift"; chars = "\\x1b:";     }

          { key = "Slash"; mods = "Alt|Shift"; chars = "\\x1b?"; }

          { key = "Back";      mods = "Alt";       chars = "\\x1b\\x7f"; }
          { key = "Backslash"; mods = "Alt";       chars = "\\x1b\\\\";  }
          { key = "Backslash"; mods = "Alt|Shift"; chars = "\\x1b|";     }
          { key = "Comma";     mods = "Alt";       chars = "\\x1b,";     }
          { key = "Comma";     mods = "Alt|Shift"; chars = "\\x1b<";     }
          { key = "Grave";     mods = "Alt";       chars = "\\x1b`";     }
          { key = "Grave";     mods = "Alt|Shift"; chars = "\\x1b~";     }

          { key = "Slash";     mods = "Alt"; chars = "\\x1b/";     }

          { key = "Key0";      mods = "Alt";       chars = "\\x1b0";     }
          { key = "Key0";      mods = "Alt|Shift"; chars = "\\x1b)";     }

          { key = "Key1";      mods = "Alt";       chars = "\\x1b1";     }
          { key = "Key1";      mods = "Alt|Shift"; chars = "\\x1b!";     }

          { key = "Key2";      mods = "Alt";       chars = "\\x1b2";     }
          { key = "Key2";      mods = "Alt|Shift"; chars = "\\x1b@";     }

          { key = "Key3";      mods = "Alt";       chars = "\\x1b3";     }
          { key = "Key3";      mods = "Alt|Shift"; chars = "\\x1b#";     }

          { key = "Key4";      mods = "Alt";       chars = "\\x1b4";     }
          { key = "Key4";      mods = "Alt|Shift"; chars = "\\x1b$";     }

          { key = "Key5";      mods = "Alt";       chars = "\\x1b5";     }
          { key = "Key5";      mods = "Alt|Shift"; chars = "\\x1b%";     }

          { key = "Key6";      mods = "Alt";       chars = "\\x1b6";     }
          { key = "Key6";      mods = "Alt|Shift"; chars = "\\x1b^";     }

          { key = "Key7";      mods = "Alt";       chars = "\\x1b7";     }
          { key = "Key7";      mods = "Alt|Shift"; chars = "\\x1b&";     }

          { key = "Key8";      mods = "Alt";       chars = "\\x1b8";     }
          { key = "Key8";      mods = "Alt|Shift"; chars = "\\x1b*";     }

          { key = "Key9";      mods = "Alt";       chars = "\\x1b9";     }
          { key = "Key9";      mods = "Alt|Shift"; chars = "\\x1b(";     }

          { key = "Minus";     mods = "Alt|Shift"; chars = "\\x1b_";     }
          { key = "Period";    mods = "Alt";       chars = "\\x1b.";     }
          { key = "Period";    mods = "Alt|Shift"; chars = "\\x1b>";     }

          { key = "LBracket";  mods = "Alt|Shift"; chars = "\\x1b{";     }
          { key = "RBracket";  mods = "Alt|Shift"; chars = "\\x1b}";     }


          { key = "Space"; mods = "Control|Alt"; chars = "\\x1b\\0"; }
        ])
      ];
    };
  };
}
