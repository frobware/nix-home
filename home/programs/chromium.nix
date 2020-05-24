{ config, lib, pkgs, ... }:

{
  programs.chromium = {
    package = pkgs.chromium.override {
      commandLineArgs = [
        "--enable-features=OverlayScrollbar"
        "--enable-gpu-rasterization"
        "--enable-oop-rasterization"
        "--ignore-gpu-blacklist"
      ];
      pulseSupport = true;
    };
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
    ];
  };
}
