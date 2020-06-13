# Installation

## Getting Nix

```sh
$ sudo chown aim:aim /nix
$ curl -L https://nixos.org/nix/install | sh
$ . $HOME/.nix-profile/etc/profile.d/nix.sh
# Validate nix is working
$ nix-instantiate '<nixpkgs>' -A hello
$ /usr/bin/git clone --recursive https://github.com/frobware/nix-home ~/.config/nixpkgs
$ nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```
