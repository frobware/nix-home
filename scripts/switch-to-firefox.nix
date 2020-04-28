{ writeShellScriptBin }:

writeShellScriptBin "switch-to-firefox" ''
  wmctrl -R firefox || (exec firefox &)
''
