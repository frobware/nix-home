{
  imports = [
    ./modules
    ./nix/auto-host.nix
    ./profiles/common.nix
  ];

  networking.hostName = hostName;
}
