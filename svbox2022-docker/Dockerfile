FROM sciviews/svbox2022-verse:latest

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/SciViews/svbox" \
      org.opencontainers.image.vendor="SciViews" \
      org.opencontainers.image.authors="Philippe Grosjean <phgrosjean@sciviews.org>" \
      org.opencontainers.image.description="SciViews Box 2022 - R 4.1.3 and RStudio plus a series of R packages for the SciViews::R dialect."

ENV DEFAULT_USER=rstudio

COPY scripts /rocker_scripts

RUN chmod +x /rocker_scripts/*.sh && /rocker_scripts/install_sciviews.sh
