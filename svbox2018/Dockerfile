FROM rocker/geospatial:3.4.4

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/sciviews/sciviews-box" \
      org.label-schema.vendor="SciViews" \
      maintainer="Philippe Grosjean <phgrosjean@sciviews.org>" \
      description="Docker version of the SciViews Box 2018"

ENV BUILD_DATE ${BUILD_DATE:-2018-04-22}

## TODO: put files in the shared directory

## automatically link a shared volume
VOLUME /home/rstudio/shared

RUN apt-get update \
  ## install packages from date-locked MRAN snapshot of CRAN
  && [ -z "$BUILD_DATE" ] && BUILD_DATE=$(TZ="America/Los_Angeles" date -I) || true \
  && MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE} \
  && echo MRAN=$MRAN >> /etc/environment \
  && export MRAN=$MRAN \
  && echo "options(repos = c(CRAN = '$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
  && Rscript -e "update.packages(repos = '$MRAN', ask = FALSE)" \
  ## Freeze texlive to latest 2017 version
  && tlmgr option repository ftp://tug.org/historic/systems/texlive/2017/tlnet-final \
  ## Clean up from R source install
  && cd / \
  && rm -rf /tmp/* \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/* \
  ## This is for CodeDepends
  && Rscript -e "source('https://bioconductor.org/biocLite.R'); biocLite('graph', suppressUpdates = TRUE); biocLite('Rgraphviz', suppressUpdates = TRUE)" \"
  ## Further SciViews packages
  && install2.r --error --deps TRUE \
    # Tidyverse extensions
    tsibble tibbletime tidygraph tidyimpute tidytext skimr naniar listless \
    replyr widyr \
    # Datasets
    babynames gapminder hflights titanic repurrrsive \
    # Date & time
    date anytime nanotime fasttime \
    # Files
    here fs archivist.github filehash filehashSQLite \
    # Import/export
    jpeg bmp tiff import googledrive writexl XLConnect XLConnectJars readODS \
    rmatio officer fst h5 ncdf4.helpers webp \
    # Databases
    mongolite RMariaDB RPostgres sqldf odbc rquery pool \
    # Plots
    googleVis manipulate gridBase ggvis graphicsQC gridSVG grImport grImport2 \
    animation beanplot Cairo fontcm DiagrammeR DiagrammeRsvg qqplotr rbokeh \
    multipanelfigure corrgram magicaxis networkD3 tactile timevis vcdExtra \
    prepplot \
    # Plots (ggplot2)
    ggcorrplot ggedit ggExtra ggfittext ggfortify ggimage ggiraph ggiraphExtra \
    ggjoy ggmap ggmosaic ggnetwork ggparallel ggplotAssist ggpmisc ggpolypath \
    ggpubr ggRandomForests ggraph ggrepel ggridges ggROC ggsci ggseas \
    ggsignif ggsn ggstance ggtern ggThemeAssist ggthemes egg cowplot breakDown \
    treemapify visreg lemon \
    # Web
    crul plumber httping jsonvalidate \
    # R markdown, knitr, etc.
    blogdown ascii captioner citr kableExtra kfigr knitrBootstrap bsplus \
    knitrProgressBar linl pinp tint tikzDevice ztable pander stargazer \
    formattable printr tangram texreg bookdownplus vembedr \
    # Reproducible research
    checkpoint drat knitcitations rmdformats sessioninfo drake statcheck liftr \
    rbundler \
    # Teaching
    swirlify learnr drawExpression \
    # Learning and documentation
    sos pryr fortunes ctv moderndive UsingR DAAG aprean3 gcookbook \
    # Programming
    CodeDepends assertive assertr checkr ensurer tester ruler vetr validate \
    checkmate msgtools setter pipeR gsubfn namespace naptime narray rlist \
    zeallot \
    # Object oriented
    proto lambda.tools \
    # Performances
    dvmisc fastcluster fastmatch OpenMPController RhpcBLASctl \
    # Other languages
    inline reticulate V8 \
    # Interprocess
    subprocess opencpu flock Rserve RSclient remoter liteq \
    # Parallel computing
    doMC doRNG doParallel doFuture future.BatchJobs future.callr snow snowfall \
    snowFT partools pbapply rlecuyer \
    # Utilities
    spelling usethis available runittotestthat benchmarkme diffobj compare \
    compareDF rcmdcheck rhub tracer keyring cranlike cranlogs crantastic sealr \
    miniCRAN getPass rclipboard Rd2roxygen Ruchardet easypackages errors units \
    lucr needs pkggraph profmem profvis prrd sets stubthat UNF pillar vdiffr \
    # Shiny
    shinyalert shinybootstrap2 shinyDND shinyFeedback shinyFiles shinyjqui \
    shinyjs shinymaterial shinyShortcut ShinyTester shinyTime shinytoastr \
    shinyTree reactR flexdashboard jsTree rhandsontable \
    # RStudio
    colourpicker convertr condformat listviewer \
    # Statistics misc
    ADGofTest agricolae akima fBasics Amelia ape corrr simecol SuppDists \
    survminer circular changepoint tripack pwr rsample rv DataExplorer \
    # Multivariate analysis
    FactoMineR vegan vegan3d ECoL ca candisc dynamicTreeCut explor \
    # Time series
    seasonal pastecs zoocat stlplus dyn dynlm fts RcppXts \
    # Modelling
    afex NISTnls nlstools nparcomp multcompView contrast \
    # Machine learning
    caret mlr mlearning lime varSelRF Rborist kohonen multiROC unbalanced \
    OOBCurve yardstick \
    # Geospatial
    shapefiles geojsonio rworldmap rworldxtra tmap tmaptools \
    # SciViews
    svMisc svSocket svHttp svIDE svGUI svDialogs svSweave svTools svWidgets \
    SciViews tcltk2

## TODO:
# data, flow, chart, SciViews, svDialogs
# abd (‘ggformula’, ‘mosaicData’, ‘mosaicCore’, ‘ggdendro’, ‘leaps’, ‘Rmpfr’,
# ‘mosaic’, ‘HH’, ‘ICC’ => Rmpfr & HH not installed), prophet (‘StanHeaders’,
# ‘extraDistr’, ‘rstan’ => rstan & prophet not installed!), BEST (‘HDInterval’,
# ‘rjags’ =>  rjags & BEST not installed), workflowr, lucid ('rjags' failed),
# esquisse a GUI for ggplot2 (https://github.com/dreamRs/esquisse)
# tsbox : time series objects converter?
# devtools::install_github(“pmur002/roloc”)
# devtools::install_github('jtleek/slipper')
# source("https://install-github.me/MangoTheCat/goodpractice”)
# devtools::install_github("ropenscilabs/testrmd"))
# wokflowr
# ggplotify
# lobstr
# checkr to supplement learnr
# infer
# ERSA: shiny exploration of regressions, but errors installing on Docker
# TODOr devtools::install_github("dokato/todor")
# inserttable (or insert_table?) devtools::install_github("lbusett/insert_table")
# fable in replacement to forecast with tidy verse compatibility
# tidymodels
# BiocManager
# bench::mark
# directlabels
# furrr mapping in parallel using future
# dqrng for fast random numbers generators
# ggdistribute
# optimParallel = same as optim(), but in parallel
# shinytest
# ggstatsplot: check dependencies!
#
# To check:
# gghighlight, ggalt, gganimate, diffdf, ssh, modules, mlrCPO, table1, tabulizer
# regexplain  (https://github.com/gadenbuie/regexplain)
