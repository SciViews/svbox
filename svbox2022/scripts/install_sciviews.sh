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

## more R package
install2.r --error --skipinstalled -n "$NCPUS" \
    ade4 anytime ape assert assertthat automap available backports base64enc \
    base64url bench bit bit64 blastula blob bookdown boot broom broom.mixed \
    butcher ca car circular cli clisymbols collapse config conflicted convertr \
    coro corrplot corrr covr cowplot crayon curl cyphr data.table datasauRus \
    DBI dbplyr devtools DiagrammeR dials digest distributional distributions3 \
    doFuture doParallel doRNG dm DT dtplyr e1071 egg ellipse esquisse evaluate \
    factoextra FactoMineR fansi faraway fastcluster fastmap feasts flashClust \
    flexdashboard flipdownr fontawesome forcats foreach formatR fortunes fs \
    furrr future future.apply future.callr gdtools generics getPass GGally \
    gganimate ggconf ggcorrplot ggdendro ggExtra ggfortify ggiraph ggpackets \
    ggpubr ggrepel ggridges ggsci ggsignif ggsn ggsom ghclass gitcreds glmnet \
    glue golem googlesheets4 gridBase gridExtra gridGraphics gstat haven here \
    Hmisc htmltools htmlwidgets httpuv httr igraph inline ipred IRkernel \
    iterators janitor job jsonlite keyring knitr knitcitations kohonen later \
    lattice latticeExtra leaflet lifecycle lindia lintr lobstr lme4 lmerTest \
    lubridate magrittr mapedit maps mapsf mapview markdown memoise \
    microbenchmark mime miniCRAN miniUI mlbench modelr mongolite mosaic \
    multcomp mvtnorm naniar nanotime nparcomp odbc pagedown pak palmerpenguins \
    pander parsnip patchwork piggyback pillar pins pkgdepends pkgdown PKI \
    plotly prettyglm printr pROC progressr promises pryr purrr pwr quantreg \
    quarto questionr R6 ragg randomForest ranger raster RColorBrewer Rcpp \
    RcppCCTZ reactlog readxl recipes rhub remotes reprex reticulate rgl \
    RhpcBLASctl rlang rmarkdown rmdformats ROCR rpart rprojroot rsample \
    rsconnect RSQLite rticles sessioninfo shiny shinydashboard shinyjs \
    shinylogs shinytest shinytoastr shinyWidgets skimr slider sloop \
    smotefamily sodium sortable sparklyr spData spelling stars stringi stringr \
    styler summarytools suppdata SuppDists svglite svUnit sys targets testthat \
    thematic tictoc tidymodels tidyr tidyverse tinytest tmap tmaptools todor \
    TSA tsibble tune usethis UsingR vctrs vegan vembedr vetiver vip viridis \
    viridisLite visdat vroom waldo warp withr workflows workflowsets writexl \
    xfun xaringan xtable xts yaml yardstick zeallot zoo

# SciViews extensions
R -e "options(repos = c(
    sciviews = 'https://sciviews.r-universe.dev',
    CRAN     = 'https://packagemanager.rstudio.com/all/__linux__/focal/2022-04-21'))
    install.packages(c('svMisc', 'svBase', 'svFlow', 'data.io', 'chart', 'SciViews'))
    remotes::install_github(c(
      'SciViews/exploreit@8aafa47',
      'phgrosjean/aurelhy@v1.0.8',
      'phgrosjean/pastecs@v1.4.1',
      'rstudio/shinytest2@v1',
      'rstudio/learnr@v0.10.5.9000',
      'rstudio/gradethis@v0.2.5.9000',
      'SciViews/learnitdown@v1.5.1')"

# Our default directory is /home/rstudio/workspace, we create it
mkdir -p "/home/${DEFAULT_USER}/workspace"
chown -R ${DEFAULT_USER}:staff "/home/${DEFAULT_USER}/workspace"

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

# Check the SciViews::R dialect
#echo -e "Check SciViews::R...\n"
#Not yet! R -q -e "SciViews::R()"

echo -e "\nInstall SciViews package, done!"
