FROM sciviews/svbox2022-saturnbase-rstudio:latest

# Adapted from https://github.com/saturncloud/images/blob/main/saturn-rstudio/Dockerfile, 2022-05-13
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/SciViews/svbox" \
      org.opencontainers.image.vendor="SciViews" \
      org.opencontainers.image.authors="Philippe Grosjean <phgrosjean@sciviews.org>" \
      org.opencontainers.image.description="SciViews Box 2022 on Saturn Cloud."

COPY environment.yml /tmp/environment.yml
COPY postBuild /tmp/postBuild.sh

RUN mamba env update -n saturn --file /tmp/environment.yml && \
    find ${CONDA_DIR} -type f,l -name '*.pyc' -delete && \
    find ${CONDA_DIR} -type f,l -name '*.a' -delete && \
    find ${CONDA_DIR} -type f,l -name '*.js.map' -delete && \
    /bin/bash -e -u -o pipefail /tmp/postBuild.sh && \
    sudo rm /tmp/postBuild.sh && \
    echo '# cmd: /opt/saturncloud/bin/conda install papermill' > ${CONDA_DIR}/envs/saturn/conda-meta/history
# history command is a hotfix for https://github.com/rstudio/reticulate/issues/1184
