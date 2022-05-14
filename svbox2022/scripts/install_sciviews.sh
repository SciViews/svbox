#!/bin/bash

set -e

## build ARGs
DEFAULT_USER=${1:-${DEFAULT_USER:-"rstudio"}}
NCPUS=${NCPUS:--1}

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install \
    libicu-dev \
    libmagick++-dev \
    libjpeg-turbo* \
    libpng16* \
    libtiff* \
    libglpk-dev \
    libsasl2-dev \
    libsecret-1-dev \
    hunspell-en-us \
    hunspell-en-gb \
    xdg-utils \
    net-tools \
    nano \
    libgit2-dev \
    libudunits2-0 \
    libproj-dev \
    libcgal-dev \
    libglu1-mesa-dev \
    libprotobuf-dev \
    protobuf-compiler

install2.r --error --skipinstalled -n "$NCPUS" \
    SuppDists \
    svMisc \
    svUnit \
    SciViews

## dplyr database backends
install2.r --error --skipinstalled -n "$NCPUS" \
    svDialogs \
    svDialogstcltk

## a bridge to far? -- brings in another 60 packages
# install2.r --error --skipinstalled -n "$NCPUS" tidymodels

# Our default directory is /home/rstudio/workspace, we create it
mkdir -p "/home/${DEFAULT_USER}/workspace"
chown -R ${DEFAULT_USER}:staff "/home/${DEFAULT_USER}/workspace"

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

# Check the SciViews::R dialect
echo -e "Check SciViews::R...\n"

#Not yet! R -q -e "SciViews::R()"

echo -e "\nInstall SciViews package, done!"
