FROM sciviews/svbox2022:latest

# Modified from https://github.com/saturncloud/images/blob/main/saturnbase-rstudio-gpu-11.1/Dockerfile
# Original vendor: Saturn Cloud
# Original author: Jacqueline Nolis
# # Almost all credits should go to her!
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/SciViews/svbox" \
      org.opencontainers.image.vendor="SciViews" \
      org.opencontainers.image.authors="Philippe Grosjean <phgrosjean@sciviews.org>" \
      org.opencontainers.image.description="SciViews Box 2022 on Saturn Cloud base image inspired by saturnbase-rstudio-gpu-11.1 by Jacqueline Nolis (all credit to her !)"

# SETUP SATURN (and install linux libraries for R & Rstudio)

EXPOSE 8888

ENV APP_BASE=/srv
ENV CONDA_DIR=/srv/conda
ENV CONDA_BIN=${CONDA_DIR}/bin
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV SHELL /bin/bash
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV USER=${NB_USER}
ENV HOME=/home/${NB_USER}

ARG TINI_VERSION=0.18.0

COPY scripts/install_saturnbase.sh /saturn_scripts/install_saturnbase.sh

RUN chmod +x /saturn_scripts/install_saturnbase.sh && /saturn_scripts/install_saturnbase.sh

USER ${NB_USER}

# Install miniconda
COPY scripts_user /tmp

RUN sudo chown 1000:1000 /tmp/*.sh && \
    sudo chmod ugo+x /tmp/*.sh && \
    bash /tmp/install-miniconda.sh && \
    bash /tmp/setup-conda.sh && \
    echo '' > ${CONDA_DIR}/conda-meta/history && \
    ${CONDA_BIN}/conda config --system --add channels conda-forge && \
    ${CONDA_BIN}/conda config --system --set auto_update_conda false && \
    ${CONDA_BIN}/conda config --system --set show_channel_urls true

ENV NPM_DIR ${APP_BASE}/npm
ENV NB_PYTHON_PREFIX ${CONDA_DIR}/envs/saturn
ENV PATH ${NB_PYTHON_PREFIX}/bin:${CONDA_BIN}:${NPM_DIR}/bin:${HOME}/.local/bin:${PATH}

WORKDIR ${HOME}

# Configure RStudio
COPY --chown=root:root scripts_user/rstudio-start.sh /usr/local/bin/rstudio-start.sh

RUN sudo chmod +x /usr/local/bin/rstudio-start.sh

COPY --chown=root:root rserver.conf /etc/rstudio/rserver.conf
COPY --chown=root:root database.conf /etc/rstudio/database.conf
# Already done in svbox2022-verse
#COPY --chown=root:root rstudio-prefs.json /etc/rstudio/rstudio-prefs.json

ENTRYPOINT ["tini", "--"]

CMD ["/usr/local/bin/rstudio-start.sh"]
