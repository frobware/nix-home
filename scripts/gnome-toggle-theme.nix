{ writeShellScriptBin }:

writeShellScriptBin "helloWorld" ''
  echo $RANDOM
''
