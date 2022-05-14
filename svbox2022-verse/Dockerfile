FROM ubuntu:focal

# Modified from https://github.com/rocker-org/rocker-versioned2 (2022-05-13):
# r-ver:4.1.3, rstudio:4.1.3, tidyverse:4.1.3 & verse:4.1.3
# Original vendor: Rocker Project
# Original author: Carl Boettiger <cboettig@ropensci.org>
# Almost all credits should go to him!
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/SciViews/svbox" \
      org.opencontainers.image.vendor="SciViews" \
      org.opencontainers.image.authors="Philippe Grosjean <phgrosjean@sciviews.org>" \
      org.opencontainers.image.description="SciViews Box 2022 base image inspired by rocker/verse:4.1.3 by Carl Boettiger <cboettig@ropensci.org (all credit to him !)."

# From r-ver:4.1.3
ENV R_VERSION=4.1.3
ENV R_HOME=/usr/local/lib/R
ENV TZ=Etc/UTC

COPY scripts/install_R_source.sh /rocker_scripts/install_R_source.sh

RUN chmod +x /rocker_scripts/install_R_source.sh && /rocker_scripts/install_R_source.sh

ENV CRAN=https://packagemanager.rstudio.com/cran/__linux__/focal/2022-04-21
ENV LANG=en_US.UTF-8

COPY scripts /rocker_scripts

RUN chmod +x /rocker_scripts/*.sh && /rocker_scripts/setup_R.sh

# From rstudio:4.1.3
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2022.02.2+485
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN /rocker_scripts/install_rstudio.sh

RUN /rocker_scripts/install_pandoc.sh

# From tidyverse:4.1.3
RUN /rocker_scripts/install_tidyverse.sh

# From verse:4.1.3
ENV CTAN_REPO=https://www.texlive.info/tlnet-archive/2022/04/21/tlnet
ENV PATH=$PATH:/usr/local/texlive/bin/x86_64-linux
ENV QUARTO_VERSION=default

RUN /rocker_scripts/install_verse.sh

RUN /rocker_scripts/install_quarto.sh

# From rstudio:4.1.3
EXPOSE 8787

# SciViews additions (not yet!)
#RUN /rocker_scripts/install_sciviews.sh

# Customize RStudio
COPY --chown=root:root rstudio-prefs.json  /etc/rstudio/rstudio-prefs.json

RUN mkdir /home/rstudio/workspace && chown -R rstudio:staff /home/rstudio/workspace

CMD ["/init"]
