#!/bin/bash

: "${GNOME_DARK_MODE:='Adwaita-dark'}"
: "${GNOME_LIGHT_MODE:='Adwaita-light'}"

get_theme() {
    gsettings get org.gnome.desktop.interface gtk-theme
}

set_theme() {
    gsettings set org.gnome.desktop.interface gtk-theme "$1"
}

case "$(get_theme)" in
    "${GNOME_LIGHT_MODE}")
	set_theme "${GNOME_DARK_MODE}"
	;;
    "${GNOME_DARK_MODE}")
	set_theme "${GNOME_LIGHT_MODE}"
	;;
esac
