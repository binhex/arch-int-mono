#!/bin/bash

# exit script if return code != 0
set -e

# resetting to live repo and using pacman for this app.
echo 'Server = http://mirror.bytemark.co.uk/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = http://archlinux.mirrors.uk2.net/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

# download fresh package databases from the server
pacman -Fyy --noconfirm

# sync package databases for pacman
pacman -Syyu --noconfirm

# build scripts
####

# download build scripts from github
curl --connect-timeout 5 --max-time 600 --retry 5 --retry-delay 0 --retry-max-time 60 -o /tmp/scripts-master.zip -L https://github.com/binhex/scripts/archive/master.zip

# pacman packages
####

# define pacman packages
pacman_packages="mono"

# install compiled packages using pacman
if [[ ! -z "${pacman_packages}" ]]; then
	pacman -S --needed $pacman_packages --noconfirm
fi

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/gtk-doc/*
rm -rf /tmp/*
