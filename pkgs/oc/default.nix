{ stdenv, pkgs, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oc";
  version = "openshift-clients-4.6.0-202006250705.p0";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = pname;
    rev = version;
    sha256 = "sha256:02i9z4im85fjyrdjpmx0kcjqy2v1mi6aw3miv3p2f4lgz0d90v2l";
  };

  buildInputs = with pkgs; [
    gpgme
  ];

  doCheck = false;

  # vendorSha256 can also take null as an input. When `null` is used
  # as a value, rather than fetching the dependencies and vendoring
  # them, we use the vendoring included within the source repo. If
  # you'd like to not have to update this field on dependency changes,
  # run `go mod vendor` in your source repo and set 'vendorSha256 =
  # null;'

  vendorSha256 = null;          # lib.sha256

  subPackages = [
    "cmd/oc"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/openshift/oc;
  };
}
