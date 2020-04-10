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
    sha256 = "1irrnvz5m676n3wsybgr2gj54ap0gh066666wx8j1flkg16d9sv4";
  };

  cargoSha256 = "1r353ap8dslsahb2gw8x90c3jmpdnx41116wzgqzbz4vps9vqr2h";
}
