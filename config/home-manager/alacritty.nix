{ config, lib, pkgs, ... }:

let

  inherit (lib) flatten optionals;
  inherit (pkgs.stdenv) isDarwin isLinux;

in

{
  programs.alacritty = {
    enable = true;

# For remapping Alacritty bindings you can see what Alacritty receives
# by running alacritty --print-events | grep "WindowEvent.*KeyboardInput".

    settings = {
      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };

        class = "Alacritty";
        decorations = "buttonless";
        dynamic_padding = true;
        startup_mode = "Maximized";
        title = "Terminal";
      };

      scrolling = {
        auto_scroll = false;
        faux_multiplier = 3;
        history = 0;
        multiplier = 3;
      };

      tabspaces = 8;

      # Font configuration (changes require restart)
      font = {
        normal = {
          family = "SF Mono";
          style = "Light";
        };

        bold = {
          family = "SF Mono";
          style = "Bold";
        };

        italic = {
          family = "SF Mono";
          style = "Regular Italic";
        };

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
          bright_background = "0x1b1b1b";
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
          # { key = "F";        mods = "Alt|Control"; action = "None";              }
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

          { key = "V";        mods = "Control|Shift";   action = "Paste";             }
          { key = "C";        mods = "Control|Shift";   action = "Copy";              }
          { key = "Insert";   mods = "Shift";           action = "PasteSelection";    }
          { key = "Key0";     mods = "Control";         action = "ResetFontSize";     }
          { key = "Equals";   mods = "Control|Shift";   action = "IncreaseFontSize";  }
          { key = "Minus";    mods = "Control";         action = "DecreaseFontSize";  }
          { key = "Return";   mods = "Alt";             action = "ToggleFullScreen";  }

          { key = "Grave";    mods = "Alt";         chars = "\\x1b`"; } # Alt + `
          { key = "Grave";    mods = "Alt|Shift";   chars = "\\x1b~"; } # Alt + `

          { key = "N"; mods = "Alt|Shift"; action = "SpawnNewInstance"; }

          { key = "X"; mods = "Alt"; chars = "\\x1bx"; }

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

          { key = "Back";      mods = "Alt";       chars = "\\x1b\\x7f"; }
          { key = "Backslash"; mods = "Alt";       chars = "\\x1b\\\\";  }
          { key = "Backslash"; mods = "Alt|Shift"; chars = "\\x1b|";     }
          { key = "Comma";     mods = "Alt";       chars = "\\x1b,";     }
          { key = "Comma";     mods = "Alt|Shift"; chars = "\\x1b<";     }
          { key = "Grave";     mods = "Alt";       chars = "\\x1b`";     }
          { key = "Grave";     mods = "Alt|Shift"; chars = "\\x1b~";     }
          { key = "Key0";      mods = "Alt";       chars = "\\x1b0";     }
          { key = "Key1";      mods = "Alt";       chars = "\\x1b1";     }
          { key = "Key2";      mods = "Alt";       chars = "\\x1b2";     }
          { key = "Key3";      mods = "Alt";       chars = "\\x1b3";     }
          { key = "Key3";      mods = "Alt|Shift"; chars = "\\x1b#";     }
          { key = "Key4";      mods = "Alt";       chars = "\\x1b4";     }
          { key = "Key5";      mods = "Alt";       chars = "\\x1b5";     }
          { key = "Key5";      mods = "Alt|Shift"; chars = "\\x1b%";     }
          { key = "Key6";      mods = "Alt";       chars = "\\x1b6";     }
          { key = "Key6";      mods = "Alt|Shift"; chars = "\\x1b^";     }
          { key = "Key7";      mods = "Alt";       chars = "\\x1b7";     }
          { key = "Key8";      mods = "Alt";       chars = "\\x1b8";     }
          { key = "Key8";      mods = "Alt|Shift"; chars = "\\x1b*";     }
          { key = "Key9";      mods = "Alt";       chars = "\\x1b9";     }
          { key = "LBracket";  mods = "Alt|Shift"; chars = "\\x1b{";     }
          { key = "Minus";     mods = "Alt|Shift"; chars = "\\x1b_";     }
          { key = "Period";    mods = "Alt";       chars = "\\x1b.";     }
          { key = "Period";    mods = "Alt|Shift"; chars = "\\x1b>";     }
          { key = "RBracket";  mods = "Alt|Shift"; chars = "\\x1b}";     }
          # { key = "Space";     mods = "Control";       chars = "\\x00";      }

          # { key = "Space";     mods = "Control|Alt";       chars= "\x1b[1;2B"; }
          { key = "Space"; mods = "Control|Alt"; chars = "\\x1b\\0"; }

          # { key = "A"; mods ="Control|Alt"; chars= "\\x1ba"; }
        ])

        # { key = "N";        mods = "Alt|Shift";   action = "SpawnNewInstance";                     }

        # { key = "Paste";                              action = "Paste";                                }
        # { key = "Copy";                               action = "Copy";                                 }
        # { key = "L";        mods = "Control";         action = "ClearLogNotice";                       }
        # { key = "L";        mods = "Control";         chars = "\\x0c";                                 }
        # { key = "Home";     mods = "Alt";             chars = "\\x1b[1;3H";                            }
        # { key = "Home";                               chars = "\\x1bOH";         mode = "AppCursor";   }
        # { key = "Home";                               chars = "\\x1b[H";         mode = "~AppCursor";  }
        # { key = "End";      mods = "Alt";             chars = "\\x1b[1;3F";                            }
        # { key = "End";                                chars = "\\x1bOF";         mode = "AppCursor";   }
        # { key = "End";                                chars = "\\x1b[F";         mode = "~AppCursor";  }
        # { key = "PageUp";   mods = "Shift";           action = "ScrollPageUp";   mode = "~Alt";        }
        # { key = "PageUp";   mods = "Shift";           chars = "\\x1b[5;2~";      mode = "Alt";         }
        # { key = "PageUp";   mods = "Control";         chars = "\\x1b[5;5~";                            }
        # { key = "PageUp";   mods = "Alt";             chars = "\\x1b[5;3~";                            }
        # { key = "PageUp";                             chars = "\\x1b[5~";                              }
        # { key = "PageDown"; mods = "Shift";           action = "ScrollPageDown"; mode = "~Alt";        }
        # { key = "PageDown"; mods = "Shift";           chars = "\\x1b[6;2~";      mode = "Alt";         }
        # { key = "PageDown"; mods = "Control";         chars = "\\x1b[6;5~";                            }
        # { key = "PageDown"; mods = "Alt";             chars = "\\x1b[6;3~";                            }
        # { key = "PageDown";                           chars = "\\x1b[6~";                              }
        # { key = "Tab";      mods = "Shift";           chars = "\\x1b[Z";                               }
        # { key = "Back";                               chars = "\\x7f";                                 }
        # { key = "Back";     mods = "Alt";             chars = "\\x1b\\x7f";                            }
        # { key = "Insert";                             chars = "\\x1b[2~";                              }
        # { key = "Delete";                             chars = "\\x1b[3~";                              }
        # { key = "Left";     mods = "Shift";           chars = "\\x1b[1;2D";                            }
        # { key = "Left";     mods = "Control";         chars = "\\x1b[1;5D";                            }
        # { key = "Left";     mods = "Alt";             chars = "\\x1b[1;3D";                            }
        # { key = "Left";                               chars = "\\x1b[D";         mode = "~AppCursor";  }
        # { key = "Left";                               chars = "\\x1bOD";         mode = "AppCursor";   }
        # { key = "Right";    mods = "Shift";           chars = "\\x1b[1;2C";                            }
        # { key = "Right";    mods = "Control";         chars = "\\x1b[1;5C";                            }
        # { key = "Right";    mods = "Alt";             chars = "\\x1b[1;3C";                            }
        # { key = "Right";                              chars = "\\x1b[C";         mode = "~AppCursor";  }
        # { key = "Right";                              chars = "\\x1bOC";         mode = "AppCursor";   }
        # { key = "Up";       mods = "Shift";           chars = "\\x1b[1;2A";                            }
        # { key = "Up";       mods = "Control";         chars = "\\x1b[1;5A";                            }
        # { key = "Up";       mods = "Alt";             chars = "\\x1b[1;3A";                            }
        # { key = "Up";                                 chars = "\\x1b[A";         mode = "~AppCursor";  }
        # { key = "Up";                                 chars = "\\x1bOA";         mode = "AppCursor";   }
        # { key = "Down";     mods = "Shift";           chars = "\\x1b[1;2B";                            }
        # { key = "Down";     mods = "Control";         chars = "\\x1b[1;5B";                            }
        # { key = "Down";     mods = "Alt";             chars = "\\x1b[1;3B";                            }
        # { key = "Down";                               chars = "\\x1b[B";         mode = "~AppCursor";  }
        # { key = "Down";                               chars = "\\x1bOB";         mode = "AppCursor";   }
        # { key = "F1";                                 chars = "\\x1bOP";                               }
        # { key = "F2";                                 chars = "\\x1bOQ";                               }
        # { key = "F3";                                 chars = "\\x1bOR";                               }
        # { key = "F4";                                 chars = "\\x1bOS";                               }
        # { key = "F5";                                 chars = "\\x1b[15~";                             }
        # { key = "F6";                                 chars = "\\x1b[17~";                             }
        # { key = "F7";                                 chars = "\\x1b[18~";                             }
        # { key = "F8";                                 chars = "\\x1b[19~";                             }
        # { key = "F9";                                 chars = "\\x1b[20~";                             }
        # { key = "F10";                                chars = "\\x1b[21~";                             }
        # { key = "F11";                                chars = "\\x1b[23~";                             }
        # { key = "F12";                                chars = "\\x1b[24~";                             }
        # { key = "F1";       mods = "Shift";           chars = "\\x1b[1;2P";                            }
        # { key = "F2";       mods = "Shift";           chars = "\\x1b[1;2Q";                            }
        # { key = "F3";       mods = "Shift";           chars = "\\x1b[1;2R";                            }
        # { key = "F4";       mods = "Shift";           chars = "\\x1b[1;2S";                            }
        # { key = "F5";       mods = "Shift";           chars = "\\x1b[15;2~";                           }
        # { key = "F6";       mods = "Shift";           chars = "\\x1b[17;2~";                           }
        # { key = "F7";       mods = "Shift";           chars = "\\x1b[18;2~";                           }
        # { key = "F8";       mods = "Shift";           chars = "\\x1b[19;2~";                           }
        # { key = "F9";       mods = "Shift";           chars = "\\x1b[20;2~";                           }
        # { key = "F10";      mods = "Shift";           chars = "\\x1b[21;2~";                           }
        # { key = "F11";      mods = "Shift";           chars = "\\x1b[23;2~";                           }
        # { key = "F12";      mods = "Shift";           chars = "\\x1b[24;2~";                           }
        # { key = "F1";       mods = "Control";         chars = "\\x1b[1;5P";                            }
        # { key = "F2";       mods = "Control";         chars = "\\x1b[1;5Q";                            }
        # { key = "F3";       mods = "Control";         chars = "\\x1b[1;5R";                            }
        # { key = "F4";       mods = "Control";         chars = "\\x1b[1;5S";                            }
        # { key = "F5";       mods = "Control";         chars = "\\x1b[15;5~";                           }
        # { key = "F6";       mods = "Control";         chars = "\\x1b[17;5~";                           }
        # { key = "F7";       mods = "Control";         chars = "\\x1b[18;5~";                           }
        # { key = "F8";       mods = "Control";         chars = "\\x1b[19;5~";                           }
        # { key = "F9";       mods = "Control";         chars = "\\x1b[20;5~";                           }
        # { key = "F10";      mods = "Control";         chars = "\\x1b[21;5~";                           }
        # { key = "F11";      mods = "Control";         chars = "\\x1b[23;5~";                           }
        # { key = "F12";      mods = "Control";         chars = "\\x1b[24;5~";                           }
        # { key = "F1";       mods = "Alt";             chars = "\\x1b[1;6P";                            }
        # { key = "F2";       mods = "Alt";             chars = "\\x1b[1;6Q";                            }
        # { key = "F3";       mods = "Alt";             chars = "\\x1b[1;6R";                            }
        # { key = "F4";       mods = "Alt";             chars = "\\x1b[1;6S";                            }
        # { key = "F5";       mods = "Alt";             chars = "\\x1b[15;6~";                           }
        # { key = "F6";       mods = "Alt";             chars = "\\x1b[17;6~";                           }
        # { key = "F7";       mods = "Alt";             chars = "\\x1b[18;6~";                           }
        # { key = "F8";       mods = "Alt";             chars = "\\x1b[19;6~";                           }
        # { key = "F9";       mods = "Alt";             chars = "\\x1b[20;6~";                           }
        # { key = "F10";      mods = "Alt";             chars = "\\x1b[21;6~";                           }
        # { key = "F11";      mods = "Alt";             chars = "\\x1b[23;6~";                           }
        # { key = "F12";      mods = "Alt";             chars = "\\x1b[24;6~";                           }
        # { key = "F1";       mods = "Super";           chars = "\\x1b[1;3P";                            }
        # { key = "F2";       mods = "Super";           chars = "\\x1b[1;3Q";                            }
        # { key = "F3";       mods = "Super";           chars = "\\x1b[1;3R";                            }
        # { key = "F4";       mods = "Super";           chars = "\\x1b[1;3S";                            }
        # { key = "F5";       mods = "Super";           chars = "\\x1b[15;3~";                           }
        # { key = "F6";       mods = "Super";           chars = "\\x1b[17;3~";                           }
        # { key = "F7";       mods = "Super";           chars = "\\x1b[18;3~";                           }
        # { key = "F8";       mods = "Super";           chars = "\\x1b[19;3~";                           }
        # { key = "F9";       mods = "Super";           chars = "\\x1b[20;3~";                           }
        # { key = "F10";      mods = "Super";           chars = "\\x1b[21;3~";                           }
        # { key = "F11";      mods = "Super";           chars = "\\x1b[23;3~";                           }
        # { key = "F12";      mods = "Super";           chars = "\\x1b[24;3~";                           }
        # { key = "NumpadEnter";                        chars = "\n";                                    }

        # # { key = "Back";       mods = "Alt"; chars = "\x1b\x7f"; }
        # # { key = "Plus";     mods = "Control|Shift"; action = "IncreaseFontSize"; }
        # { key = "Minus";     mods = "Control"; action = "DecreaseFontSize"; }

      ];
    };
  };
}