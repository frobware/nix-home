{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomodifytags";
  version = "v1.6.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = pname;
    rev = version;
    sha256 = "1wmzl5sk5mc46njzn86007sqyyv6han058ppiw536qyhk88rzazq";
  };

  modSha256 = "0nkdk2zgnwsg9lv20vqk2lshk4g9fqwqxd5bpr78nlahb9xk486s";

  meta = with stdenv.lib; {
    homepage    = https://github.com/fatih/gomodifytags;
    description = "Go tool to modify struct field tags";
  };
}
