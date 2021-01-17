# Install nix/nix-darwin/home-manager

## Note: original copies of /etc/zshrc /etc/zprofile /etc/bashrc

Copies of the originals (as of Catalina) should I inadvertantly delete
them.

### /etc/zshrc

	# System-wide profile for interactive zsh(1) shells.

	# Setup user specific overrides for this in ~/.zshrc. See zshbuiltins(1)
	# and zshoptions(1) for more details.

	# Correctly display UTF-8 with combining characters.
	if [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
		setopt COMBINING_CHARS
	fi

	# Disable the log builtin, so we don't conflict with /usr/bin/log
	disable log

	# Save command history
	HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
	HISTSIZE=2000
	SAVEHIST=1000

	# Beep on error
	setopt BEEP

	# Use keycodes (generated via zkbd) if present, otherwise fallback on
	# values from terminfo
	if [[ -r ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR} ]] ; then
		source ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR}
	else
		typeset -g -A key

		[[ -n "$terminfo[kf1]" ]] && key[F1]=$terminfo[kf1]
		[[ -n "$terminfo[kf2]" ]] && key[F2]=$terminfo[kf2]
		[[ -n "$terminfo[kf3]" ]] && key[F3]=$terminfo[kf3]
		[[ -n "$terminfo[kf4]" ]] && key[F4]=$terminfo[kf4]
		[[ -n "$terminfo[kf5]" ]] && key[F5]=$terminfo[kf5]
		[[ -n "$terminfo[kf6]" ]] && key[F6]=$terminfo[kf6]
		[[ -n "$terminfo[kf7]" ]] && key[F7]=$terminfo[kf7]
		[[ -n "$terminfo[kf8]" ]] && key[F8]=$terminfo[kf8]
		[[ -n "$terminfo[kf9]" ]] && key[F9]=$terminfo[kf9]
		[[ -n "$terminfo[kf10]" ]] && key[F10]=$terminfo[kf10]
		[[ -n "$terminfo[kf11]" ]] && key[F11]=$terminfo[kf11]
		[[ -n "$terminfo[kf12]" ]] && key[F12]=$terminfo[kf12]
		[[ -n "$terminfo[kf13]" ]] && key[F13]=$terminfo[kf13]
		[[ -n "$terminfo[kf14]" ]] && key[F14]=$terminfo[kf14]
		[[ -n "$terminfo[kf15]" ]] && key[F15]=$terminfo[kf15]
		[[ -n "$terminfo[kf16]" ]] && key[F16]=$terminfo[kf16]
		[[ -n "$terminfo[kf17]" ]] && key[F17]=$terminfo[kf17]
		[[ -n "$terminfo[kf18]" ]] && key[F18]=$terminfo[kf18]
		[[ -n "$terminfo[kf19]" ]] && key[F19]=$terminfo[kf19]
		[[ -n "$terminfo[kf20]" ]] && key[F20]=$terminfo[kf20]
		[[ -n "$terminfo[kbs]" ]] && key[Backspace]=$terminfo[kbs]
		[[ -n "$terminfo[kich1]" ]] && key[Insert]=$terminfo[kich1]
		[[ -n "$terminfo[kdch1]" ]] && key[Delete]=$terminfo[kdch1]
		[[ -n "$terminfo[khome]" ]] && key[Home]=$terminfo[khome]
		[[ -n "$terminfo[kend]" ]] && key[End]=$terminfo[kend]
		[[ -n "$terminfo[kpp]" ]] && key[PageUp]=$terminfo[kpp]
		[[ -n "$terminfo[knp]" ]] && key[PageDown]=$terminfo[knp]
		[[ -n "$terminfo[kcuu1]" ]] && key[Up]=$terminfo[kcuu1]
		[[ -n "$terminfo[kcub1]" ]] && key[Left]=$terminfo[kcub1]
		[[ -n "$terminfo[kcud1]" ]] && key[Down]=$terminfo[kcud1]
		[[ -n "$terminfo[kcuf1]" ]] && key[Right]=$terminfo[kcuf1]
	fi

	# Default key bindings
	[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
	[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
	[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
	[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
	[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search

	# Default prompt
	PS1="%n@%m %1~ %# "

	# Useful support for interacting with Terminal.app or other terminal programs
	[ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"

### /etc/zprofile

	# System-wide profile for interactive zsh(1) login shells.

	# Setup user specific overrides for this in ~/.zprofile. See zshbuiltins(1)
	# and zshoptions(1) for more details.

	if [ -x /usr/libexec/path_helper ]; then
		eval `/usr/libexec/path_helper -s`
	fi

### /etc/bashrc

	# System-wide .bashrc file for interactive bash(1) shells.
	if [ -z "$PS1" ]; then
	   return
	fi

	PS1='\h:\W \u\$ '
	# Make bash check its window size after a process completes
	shopt -s checkwinsize

	[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"


## Install Nix 

    sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
    . $HOME/.nix-profile/etc/profile.d/nix.sh

## Install nix-darwin

    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer
	
Accept the defaults, answering 'y' to integrating wuth /etc/bash and /etc/zsh*	

## Install home-manager channel
	
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	
# Symlink my existing nix-darwin setup

	(cd ~/.nixpkgs; rm -f darwin-configuration.nix configuration.nix; ln -s ../..config/nixpkgs/darwin/configuration.nix)
    darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
    darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/configuration.nix

# Fixes

    export NIX_PATH=darwin-config=$HOME/.config/nixpkgs/configuration.nix:$HOME/.nix-defexpr/channels

# References

1. https://medium.com/@robinbb/install-nix-on-macos-catalina-ca8c03a225fc
1. 

# Uninstall

# Issues

1. https://github.com/NixOS/nix/issues/2982

# Busted

nix-shell -p nix-info --run "nix-info -m"

# /etc/hosts

# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
