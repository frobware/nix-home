{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rust-analyzer
    clippy
    cargo
    rustc

    # Rust-based coreutils
    amber                       # sed/xargs
    as-tree
    dust                        # du
    exa                         # ls
    fd                          # find
    hyperfine                   # time
    procs                       # ps
    sd                          # sed
    tokei                       # wc -l
    xsv                         # csv
    zenith                      # top

  ];
}
