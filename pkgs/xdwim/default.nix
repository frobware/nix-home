{ lib, pkgs, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "xdwim";
  version = "8724b19f3e56bb458fa0d4ecd6959edd35792b0f";

  buildInputs = with pkgs; [
    binutils
    cargo
    gcc
    gnumake
    openssl
    pkgconfig
    rustc
    xdotool
    direnv
  ];

  src = fetchFromGitHub {
    owner = "frobware";
    repo = pname;
    rev = version;
    sha256 = "sha256:1imqaygr24ndilrrgsd87kl64n2baiwx0f4nh618bmy88c4cvcl7";
  };

  cargoSha256 = "sha256:0bzv6sfl3g9r4qnrvjdqskhpwq4d8nl2f4jxrpqmiv286f2nw4f5";
}
