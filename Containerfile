FROM 	quay.io/toolbx-images/archlinux-toolbox:latest

LABEL 	com.github.containers.toolbox="true" \
      	usage="arch container that is easier to use" \
      	summary="This image is arch with yay, git, and base-devel preinstalled" \
      	maintainer="dnkmmr"

RUN	pacman -Syu --noconfirm

RUN   	ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      	ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      	ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      	ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
      	ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
     
RUN	pacman -S base-devel git just --noconfirm

# Create build user
RUN   	useradd -m --shell=/bin/bash build && usermod -L build && \
      	echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
      	echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER	build
WORKDIR	/home/build

RUN	git clone https://aur.archlinux.org/yay.git && \
	cd yay && \
	makepkg -si --noconfirm

USER 	root
WORKDIR /
