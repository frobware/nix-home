{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "golist";
  version = "4269c7041295a2ae8830a74cd66f18c7cd718c4c";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = pname;
    rev = version;
    sha256 = "1agn2294wah5bny9hgc35g2wagq81i9hn1m0py0j5xgy4g6736y3";
  };

  vendorModSha256 = null;

  meta = with stdenv.lib; {
    homepage    = https://github.com/marwan-at-work/golist;
    description = "A server that caches the go list command";
  };
}
