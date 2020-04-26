{ writeShellScriptBin }:

writeShellScriptBin "gnome-toggle-theme" ''
  ${builtins.readFile ./gnome-toggle-theme.bash}
''
