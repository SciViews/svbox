#!/bin/bash

set -e

## build ARGs
APP_BASE=${APP_BASE:/srv}
NB_USER=${NB_USER:jovyan}
#NB_UID=${NB_UID:1000}
NCPUS=${NCPUS:--1}
TINI_VERSION=${TINI_VERSION:0.18.0}

# Make all library folders readable then let R known, then set up reticulate package
mkdir -p "/usr/local/lib/R/site-library"
chown 1000:1000 -R /usr/local/lib/R
chmod 777 -R /usr/local/lib/R
su -c "echo 'RETICULATE_PYTHON=/opt/saturncloud/envs/saturn/bin/python' >> /usr/local/lib/R/etc/Renviron.site"
su -c "echo 'RSTUDIO_PANDOC=/usr/lib/rstudio-server/bin/pandoc' >> /usr/local/lib/R/etc/Renviron.site"

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt-get -qq --allow-releaseinfo-change update
apt_install \
    awscli \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    devscripts \
    file \
    gdebi-core \
    gettext-base \
    git \
    gnupg \
    htop \
    libcap2 \
    libcurl4-openssl-dev \
    libglib2.0-0 \
    libpq5 \
    libsm6 \
    libssl-dev \
    libssl1.1 \
    libuser \
    libuser1-dev \
    libxml2 \
    libxml2-dev \
    libzmq3-dev \
    locales \
    openssh-client \
    openssh-server \
    openssl \
    psmisc \
    qpdf \
    rrdtool \
    rsync \
    screen \
    ssh \
    sudo \
    wget \
    unixodbc \
    unixodbc-dev \
    libglpk-dev

# Runtime settings
sudo curl -L -o /usr/local/bin/tini https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini
sudo chmod +x /usr/local/bin/tini

# Add a few R packages that are useful for RMarkdown
install2.r --error --skipinstalled -n "$NCPUS" \
    jquerylib \
    markdown \
    rmarkdown \
    tinytex

# add snowflake ODBC driver
sudo apt-get install -f
wget https://sfc-repo.snowflakecomputing.com/odbc/linux/2.24.0/snowflake-odbc-2.24.0.x86_64.deb -O snowflake-odbc.deb
sudo dpkg -i snowflake-odbc.deb
sudo wget https://saturn-public-data.s3.us-east-2.amazonaws.com/r-odbc/odbc.ini -O /usr/lib/snowflake/odbc/lib/odbc.ini
sudo wget https://saturn-public-data.s3.us-east-2.amazonaws.com/r-odbc/odbcinst.ini -O /usr/lib/snowflake/odbc/lib/odbcinst.ini

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

# Default user with UID 1000 has to be changfed (rstudio -> jovyan)
mkdir -p /run/sshd
chmod 755 /run/sshd
# Generate locales
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
# A user rstudio/rstudio is already created with UID 1000
groupmod -g 1001 rstudio
usermod -u 1001 -g 1001 rstudio
# Create new user
adduser --disabled-password --uid ${NB_UID} --gecos "Default user" ${NB_USER}
# Give user sudo access
echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
mkdir -p ${APP_BASE}
mkdir -p /opt/saturncloud
ln -s /opt/saturncloud /srv/conda
# Give user ownership of conda and app
chown 1000:1000 -R /opt/saturncloud
chown -R $NB_USER:$NB_USER ${APP_BASE}

echo -e "\nInstall Saturnbase, done!"
