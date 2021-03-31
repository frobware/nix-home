{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rust-analyzer
    clippy
    cargo
    rustc

    # Rust-based coreutils
    amber                       # sed/xargs
    dust                        # du
    exa                         # ls
    fd                          # find
    hyperfine                   # time
    procs                       # ps
    ripgrep
    sd                          # sed
    tokei                       # wc -l
    watchexec                   # used by emacs/straight
    xsv                         # csv
    zenith                      # top
  ];
}
