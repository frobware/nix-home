{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "impl";
  version = "v1.0.0";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = pname;
    rev = version;
    sha256 = "0l21fkcgiaaf6ka91dmz8hx0l3nbp0kqi8p25kij1s5zb796z0dy";
  };

  modSha256 = "1p1wahmi41jbx6rk60vqnxab0mq5lsr1fbrqs604gx94npk1s14d";

  meta = with stdenv.lib; {
    homepage    = https://github.com/josharian/impl;
    description = "impl generates method stubs for implementing a Go interface.";
  };
}
