{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "impl";
  version = "1.0.0";
  vendorSha256 = "0xkalwy02w62px01jdwwr3vwwsh50f22dsxf8lrrwmw6k0rq57zv";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l21fkcgiaaf6ka91dmz8hx0l3nbp0kqi8p25kij1s5zb796z0dy";
  };

  meta = with stdenv.lib; {
    homepage    = https://github.com/josharian/impl;
    description = "impl generates method stubs for implementing a Go interface.";
  };
}
