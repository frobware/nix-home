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
    sha256 = "sha256:0ckfbcq24m55br9iylcx50a9g7x89hkfqh26dxn0y0i1hbpya6pr";
  };

  cargoSha256 = "sha256:1dansavnpp61mc65lbr4jbi45y6r0yki7h8xna42gxhxw5hsk9g9";
}
