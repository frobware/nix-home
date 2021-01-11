#!/usr/bin/env sh

set -eu

rm -f /etc/bashrc
rm -f /etc/zprofile
rm -f /etc/zshrc
rm -f /etc/static

cp -a /etc/bashrc.orig /etc/bashrc
cp -a /etc/zprofile.orig /etc/zprofile
cp -a /etc/zshrc.orig /etc/zshrc
