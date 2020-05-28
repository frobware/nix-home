{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reftools";
  version = "65925cf013156409e591f7a1be4df96f640d02f4";

  src = fetchFromGitHub {
    owner = "davidrjenni";
    repo = pname;
    rev = version;
    sha256 = "18jg13skqi2v2vh2k6jvazv6ymhhybangjd23xn2asfk9g6cvnjs";
  };

  subPackages = [
    "cmd/fillstruct"
    "cmd/fillswitch"
    "cmd/fixplurals"
  ];

  vendorSha256 = null;

  meta = with stdenv.lib; {
    homepage    = https://github.com/davidrjenni/reftools;
    description = "Fill golang struct in emacs";
  };
}
