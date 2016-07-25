FROM base/archlinux:latest
MAINTAINER "Victor Engmark" <victor.engmark@gmail.com>
RUN pacman --noconfirm --refresh --sync archlinux-keyring pacman && \
    pacman-key --refresh-keys && \
    pacman-db-upgrade && \
    pacman --clean --sync
RUN pacman --noconfirm --refresh --sync --sysupgrade && \
    pacman --clean --sync
RUN pacman-db-upgrade
RUN pacman --noconfirm --refresh --sync puppet ruby && \
    pacman --sync --clean
ADD . /media/root
