{
  home.file.".emacs.d/snippets/go-mode/<<".text = ''
$1 = append(''${1:slice}, ''${2:value})
  '';

  home.file.".emacs.d/snippets/go-mode/ife".text = ''
if err != nil {
				$0
}
  '';

  home.file.".emacs.d/snippets/go-mode/dd".text = ''
fmt.Printf("%+v\n", $1)
  '';

  home.file.".emacs.d/snippets/go-mode/sw".text = ''
switch $1 {
case $2:
        $0
}
  '';

  home.file.".emacs.d/snippets/go-mode/fr".text = ''
for ''${3:k}, ''${2:v} := range ''${1:target} {
        $0
}
  '';
}
