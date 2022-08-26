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
    svGUI \
    svDialogs \
    svDialogstcltk \
    SciViews

## more R package
install2.r --error --skipinstalled -n "$NCPUS" \
    agricolae ape archivist archivist.github argon2 arkdb attachment attempt \
    automap babynames base64url bench bitops blastula broom.helpers \
    broom.mixed butcher ca captioner checkmate circular clisymbols \
    colourpicker config conflicted convertr coro corrplot corrr covr cowplot \
    crosstable cyphr DataExplorer datasauRus dials distributional doFuture \
    doParallel doRNG DT egg ellipse ensurer equatags errors exams factoextra \
    FactoMineR fastai feasts filehash filehashSQLite filelock flashClust \
    flashlight flexdashboard flextable flipdownr fontawesome foreach formatR \
    formula.tools ftExtra furrr future.apply future.callr gapminder getPass
    GGally gganimate ggcorrplot ggdendro ggExtra ggfocus ggforce ggfortify
    ggfun ggimage ggiraph gglm ggmap ggmosaic ggplotify ggpubr ggRandomForests \
    ggrepel ggridges ggsci ggside ggsignif ggsn ggsom ggtext ggTimeSeries \
    ggwordcloud golem goodpractice gridGraphics gt gtsummary here hms \
    htmlTable huxtable igraph infer inline IRkernel iterators janitor job \
    kableExtra keyring knitcitations kohonen labelled Lahman latticeExtra
    lintr listcomp lmtest lobstr logger magick mapedit matrixStats Metrics \
    MetricsWeighted microbenchmark mlbench mlearning mlflow mockery modeldata \
    ModelMetrics mongolite mvtnorm naniar nortest odbc officedown officer \
    operator.tools oysteR pagedown palmerpenguins parsedate parsermd parsnip \
    pastecs patchwork PERMANOVA piggyback pingr pins pkgdepends pkgdown plotly \
    plumber pointblank prettyglm printr pROC proto pryr pwr quantities \
    quantreg questionr quickcheck ragg randomForest ranger RcppExamples \
    reactlog recipes remoter renv repr rhub rocker ROCR rpart.plot rsample \
    rstatix rvg seasonal seasonalview settings shinybusy shinydashboard \
    shinyjs shinylogs shinytest shinytoastr shinyWidgets skimr slider \
    smotefamily sodium sparklyr spData spelling stlplus survminer tab tables \
    tactile targets texreg tidycat tidylog tidymodels tiff titanic trackdown \
    tsibble tune urltools validate validatedb vegan vembedr vip visdat warp \
    workflows workflowsets writexl x13binary xgboost yaImpute yardstick \
    zeallot ztable \
    jpeg reticulate

## a bridge too far? -- brings in another 60 packages
# install2.r --error --skipinstalled -n "$NCPUS" tidymodels

# SciViews extensions
R -e "options(repos = c(
    sciviews = 'https://sciviews.r-universe.dev',
    CRAN     = 'https://packagemanager.rstudio.com/all/__linux__/focal/2022-04-21'))
    install.packages(c('svMisc', 'svBase', 'svFlow', 'data.io', 'chart', 'SciViews'))
    remotes::install_github(c('SciViews/exploreit', 'phgrosjean/aurelhy',
      'rstudio/learnr', 'rstudio/gradethis', 'SciViews/learnitdown',
      'rundel/learnrhash')
    "

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
