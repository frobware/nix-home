{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomodifytags";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wmzl5sk5mc46njzn86007sqyyv6han058ppiw536qyhk88rzazq";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    homepage    = https://github.com/fatih/gomodifytags;
    description = "Go tool to modify struct field tags";
  };
}
