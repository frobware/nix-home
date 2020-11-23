{ lib, pkgs, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "xdwim";
  version = "master";

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

  cargoSha256 = "sha256:1dansavnpp61mc65lbr4jbi45y6r0yki7h8xna42gxhxw5hsk9g9";
}
