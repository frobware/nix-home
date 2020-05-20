{ pkgs, writeShellScriptBin }:

writeShellScriptBin "switch-to-firefox" ''
  ${pkgs.wmctrl}/bin/wmctrl -R firefox || (exec firefox &)
''
