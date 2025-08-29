# Install svbox2024 SaturnCloud, based on 2023.09.01
#
# Differences in packages:
# package       mac     SaturnCloud
# backports     1.4.1   1.5.0
# boot          1.3-30  1.3-28.1  -> update
# brio          1.1.4   1.1.5
# broom         1.0.5   1.0.6
# bslib         0.7.0   0.6.1     -> update
# class         7.3-22  7.3-21    -> update
# cluster       2.1.6   2.1.4     -> update
# codetools     0.2-20  0.2-19    -> update
# commonmark    1.9.1   1.9.0     -> update
# crayon        1.5.2   1.5.3
# DBI           1.2.2   1.2.3
# digest        0.6.35  0.6.34    -> update
# downlit       0.4.3   0.4.4
# farver        2.1.1   2.1.2
# foreign       0.8-86  0.8-84    -> update
# ggplot2       3.5.0   3.5.1
# gtable        0.3.4   0.3.5
# htmltools     0.5.8.1 0.5.7     -> update
# KernSmooth    2.23-22 2.23-20   -> update
# knitr         1.46    1.45      -> update
# lattice       0.22-6  0.21-8    -> update
# littler       0.3.20  0.3.18    -> update
# MASS          7.3-60.0.1  7.3-58.4    -> update
# Matrix        1.6-5   1.5-4     -> update
# mgcv          1.9-1   1.8-42    -> update
# nlme          3.1-164 3.1-162   -> update
# nnet          7.3-19  7.3-18    -> update
# odbc          1.4.2   1.5.0
# openssl       2.1.1   2.2.0
# pkgload       1.3.4   1.4.0
# ps            1.7.6   1.7.7
# ragg          1.3.0   1.3.2
# reticulate    1.36.0  1.38.0
# rmarkdown     2.26    2.25      -> update
# roxygen2      7.3.1   7.3.2
# rpart         4.1.23  4.1.19    -> update
# sass          0.4.9   0.4.8     -> update
# spatial       7.3-17  7.3-16    -> update
# survival      3.5-8   3.5-5     -> update
# systemfonts   1.0.6   1.1.0
# textshaping   0.3.7   0.4.0
# tinytex       0.50    0.49     -> update
# xfun          0.43    0.41     -> update
# xopen         1.0.0   1.0.1

# Make sure to configure the machine with:
# Apt -> pandoc-citeproc sqlite3 optipng nano net-tools xclip libglu1-mesa-dev
#        libsecret-1-dev libudunits2-0 libmagick++-dev libgit2-dev libxslt1-dev
#        odbc-postgresql libsqliteodbc libproj-dev libgdal-dev libapparmor-dev
#        fonts-firacode
#
# Environment variables:
# LANG=fr_FR.UTF-8
# R_LIBS=/home/jovyan/shared/svbox2024/.R/library/4.3:/usr/local/lib/R/site-library:/usr/local/lib/R/library
# TIMEOUT=60
#
# Create a shared folder sdd/svbox2024, as /home/jovyan/shared/svbox2024

# Launch R in sudo mode in SaturnCloud in a terminal

orepos <- getOption("repos")
repos = c(SciViews = "https://sciviews.r-universe.dev", CRAN = "@CRAN")
# For Ubuntu 22.04LTS Jammy Jellyfish
repos["CRAN"] <- "https://packagemanager.posit.co/cran/__linux__/jammy/2024-04-20"
options(repos = repos)
options(timeout = 800) # Needed for sf and terra, increase if needed
Ncpus <- parallel::detectCores(logical = FALSE)
# If you don't want parallel install
#Ncpus <- 1L
# If there is a source package more recent than the binary, compile it:
options(install.packages.check.source = "yes")

# Create in a terminal .R/library/4.3 in the shared folder and give write permission
#
# Change .libPaths in order to install packages in the shared folder sdd/svbox2024 -> /home/jovyan/shared/svbox2024
.libPaths(c("/home/jovyan/shared/svbox2024/.R/library/4.3", .libPaths()))

update.packages(instlib = "/home/jovyan/shared/svbox2024/.R/library/4.3")

# Now, we install more packages for SciViews::R

install.packages("webshot")
webshot::install_phantomjs() # In a plain R session

# Note: there is somewhere a dependency to terra_1.5-21 that makes 100.9MB!!!
# => try to get rid of it! Note: terra is supposed to replace raster
# sf weights 95.9MB also! (BH = 12MB)
install.packages("BH")
# First check the compiled version
install.packages("units")
#... if OK:
library(units) # Does it loads without errors? If not, do the following:
# Needs brew install udunits (brew install udunits and possibly addapt the path)
#install.packages("units", configure.args = c("--with-udunits2-include=/opt/homebrew/Cellar/udunits/2.2.28/include", "--with-udunits2-lib=/opt/homebrew/Cellar/udunits/2.2.28/lib"), type = "source")
# Needs brew install pkg-config && brew install gdal
install.packages("sf") #, configure.args = "--with-proj-lib=$(brew --prefix)/lib/")
install.packages("terra")
install.packages("rpart.plot")
# Prefer installing this with parallel computation, but done at the end:
#install.packages("data.table")
install.packages("ade4") # Requires RcppArmadillo + gfortran correctly installed
install.packages("nloptr") # Requires brew install cmake
#install.packages("gert") # Requires brew install libgit2
#install.packages("textshaping") # Requires brew install harfbuzz fribidi
install.packages("ggiraph") # Requires brew install libpng, needs a Makevars file!
install.packages("svglite") # Requires brew install libpng
install.packages(c("anytime", "ape", "assert", "assertthat", "automap",
  "available", #"backports", "base64enc",
  "base64url", "bench", #"bit", "bit64",
  "blastula", #"blob",
  "bookdown", #"boot", "broom",
  "broom.mixed", "butcher",
  "ca", "car", "chromote", "circular", #"cli",
  "clisymbols", "coin", "collapse",
  "config", #"conflicted",
  "convertr", "coro", "corrplot", "corrr", "covr",
  "cowplot", #"crayon", "curl",
  "cyphr", "datasauRus", #"DBI", "dbplyr", "devtools",
  "DiagrammeR", "dials", #"digest",
  "discrim", "distributional", "distributions3", "doFuture", "doParallel", "doRNG", "dm",
  "DT", #"dtplyr",
  "duckdb", "e1071", "egg", "ellipse", "emmeans", "esquisse", #"evaluate",
  "factoextra", "FactoMineR", #"fansi",
  "faraway", "fastcluster", #"fastmap",
  "feasts", "flashClust", "flexdashboard", "flipdownr", #"fontawesome", "forcats",
  "foreach", "formatR", "fortunes", #"fs",
  "furrr", "future", "future.apply", "future.callr", "gdtools", #"generics",
  "getPass",
  "GGally", "gganimate", #"ggconf" not available because archived?!,
  "ggcorrplot", "ggdendro", "ggExtra", "ggfortify", "ggpackets", "ggpubr",
  "ggrepel", "ggridges", "ggsci", "ggsignif",
  # Replace ggsn not available any more by ggspatial later on
  "ggsom", "ghclass", #"gitcreds",
  "glmnet", #"glue",
  "golem", #"googlesheets4",
  "gridBase", "gridExtra", "gridGraphics", "gstat", #"haven", "here",
  "Hmisc", #"htmltools", "htmlwidgets", "httpuv", "httr",
  "igraph",
  "inline", "ipred", #"IRkernel" # No, not for macOS
  "iterators", "janitor", "job", #"jsonlite",
  "keyring", "kernlab", "kknn", #"knitr",
  "knitcitations", "kohonen", #"later", "lattice",
  "latticeExtra", "leaflet", "LiblineaR", #"lifecycle",
  "lindia",
  "lintr", "lobstr", "lme4", "lmerTest", "lubridate", #"magrittr",
  "mapedit",
  "maps", "mapsf", "mapview", #"markdown", "memoise",
  "microbenchmark", "mime", "miniCRAN", #"miniUI",
  "mlbench", #"modelr",
  "mongolite", "mosaic", "multcomp",
  "mvtnorm", "naniar", "nanotime", "nparcomp", "nycflights13", #"odbc",
  "pagedown", "pak", "palmerpenguins", "pander", "parsnip", "patchwork",
  "piggyback", #"pillar",
  "pins", "pkgdepends", #"pkgdown",
  "PKI", "plotly",
  "prettyglm", "printr", "pROC", "progressr", #"promises",
  "pryr", #"purrr",
  "pwr", "quantreg", "quarto", "questionr", #"R6", "ragg",
  "randomForest",
  "ranger", "raster", #"RColorBrewer", "Rcpp",
  "RcppCCTZ", "reactlog", #"readxl",
  "recipes", "rhub", #"remotes", "reprex", "reticulate",
  "rgl", "RhpcBLASctl", #"rlang", "rmarkdown",
  "rmdformats", "ROCR", #"rpart", "rprojroot",
  "rsample",
  "rsconnect", "RSQLite", "rticles", #"sessioninfo", "shiny",
  "shinydashboard",
  "shinyjs", "shinylogs", "shinytest", "shinytoastr", "shinyWidgets", "skimr",
  "slider", "sloop", "smotefamily", "sodium", "sortable", #"sparklyr", # Not on SaturnCloud
  "spData",
  "spelling", "stars", #"stringi", "stringr",
  "styler", "summarytools",
  "suppdata", "SuppDists", "svUnit", #"sys",
  "targets", #"testthat",
  "thematic", "tictoc", "tidymodels", #"tidyr", "tidyverse",
  "tinytest", "tmap",
  "tmaptools", "todor", "transformr", "TSA", "tsibble", "tune", #"usethis",
  "UsingR", #"vctrs",
  "vegan", "vembedr", "vetiver", "vip", "viridis", #"viridisLite",
  "visdat", #"vroom", "waldo",
  "warp", #"withr",
  "workflows",
  "workflowsets", "writexl", "WriteXLS", "xaringan", #"xfun", "xtable",
  "xts", #"yaml",
  "yardstick", "zeallot", "zoo"), Ncpus = Ncpus)

# From Bioconductor
install.packages("BiocManager")
BiocManager::install(c("graph", "ComplexHeatmap", "Rgraphviz" #, "RDRToolbox"
), update = FALSE, ask = FALSE)

# Dependencies for packages installed with install_from_url()
install.packages("magick") # 37.2MB
install.packages(c("getPass", "ggplotify", "proto", "renv", "shinylogs",
  "shinytoastr", "tsibble"), Ncpus = Ncpus)

#remotes::install_github("r-lib/usethis@v2.1.6") # For v2 R CMD check GitHub actions

# For packages not on CRAN, I install from URL (note: remotes::install_github()
# or remotes::install_url() are problematic because they call GitHub API with
# limit of 60hits/hour and lead to broken RStudio when launched from JupyterHub)
#install_from_url <- function(url) {
#  if (file.exists("/home/rstudio")) {# In Saturn-cloud or RStudio server
#    file <- file.path("/home/rstudio", basename(url))
#  } else {# We assume we are in RStudio Desktop on MacOS
#    file <- file.path("~/Downloads", basename(url))
#  }
#  on.exit(unlink(file))
#  download.file(url, file)
#  install.packages(file, repos = NULL)
#}

##### Install packages from GitHub
# Now replaced bi R-universe
#remotes::install_github('RConsortium/S7@v0.1.0')
#remotes::install_github('r-lib/usethis@v2.2.2')
#remotes::install_github('r-lib/rlang@v1.1.1') # Minimum version required for chart
#remotes::install_github("CredibilityLab/groundhog@v3.1.0")
#remotes::install_github('ardata-fr/equatags@87f0660')
#remotes::install_github(c(
#  'datalorax/equatiomatic@29ff168',
#  'davidgohel/flextable@d83848c',
#  'SciViews/mlearning@v1.2.1',
#  'phgrosjean/pastecs@v1.4.1',
#  'phgrosjean/aurelhy@v1.0.9',
#  'SciViews/svMisc@v1.4.0',
#  'SciViews/svBase@v1.4.0',
#  'SciViews/svFlow@v1.2.1',
#  'SciViews/data.io@v1.5.0',
#  'SciViews/chart@v1.5.1',
#  'SciViews/SciViews@1.6.1',
#  'SciViews/exploreit@v1.0.2',
#  'SciViews/modelit@v1.4.2',
#  'SciViews/inferit@v0.3.0',
#  'SciViews/tabularise@v0.5.0'
#), upgrade = 'never')
install.packages(c("S7", #"usethis", "rlang",
  "groundhog", "equatags",
  "equatiomatic", "flextable", "mlearning", "pastecs", "aurelhy", "svMisc",
  "svBase", "svFlow", "data.io", "chart", "SciViews", "exploreit", "modelit",
  "inferit", "tabularise"), Ncpus = Ncpus,
  lib = "/home/jovyan/shared/svbox2024/.R/library/4.3")
#/usr/local/lib/R/sciviews-library

##### Old code to update
# SciViews::R
#remotes::install_github("SciViews/mlearning@v1.2.0")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/mlearning_1.2.0.tar.gz")
#remotes::install_github("phgrosjean/pastecs@v1.4.1")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/pastecs_1.4.1.tar.gz")
#remotes::install_github("phgrosjean/aurelhy@v1.0.8")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/aurelhy_1.0.8.tar.gz")
#remotes::install_github("SciViews/svMisc@v1.3.1")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/svMisc_1.3.1.tar.gz")
#remotes::install_github("SciViews/svBase@v1.2.1")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/svBase_1.2.1.tar.gz")
#remotes::install_github("SciViews/svFlow@v1.2.1")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/svFlow_1.2.1.tar.gz")
#remotes::install_github("SciViews/data.io@v1.4.1")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/data.io_1.4.1.tar.gz")
#remotes::install_github("SciViews/chart@v1.4.0")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/chart_1.4.0.tar.gz")
#remotes::install_github("SciViews/SciViews@v1.5.0")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/SciViews_1.5.0.tar.gz")
#remotes::install_github("SciViews/exploreit@v1.0.0")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/exploreit_1.0.0.tar.gz")
#remotes::install_github("SciViews/modelit@v1.4.2")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/modelit_1.4.2.tar.gz")

#remotes::install_github("rstudio/shinytest2@v1", upgrade = "never")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/shinytest2_0.1.0.9000.tar.gz")
#remotes::install_github("rstudio/learnr@v0.10.5.9000", upgrade = "never")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/learnr_0.10.5.9000.tar.gz")
#remotes::install_github("rstudio/gradethis@v0.2.8.9000", upgrade = "never")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/gradethis_0.2.8.9000.tar.gz")

#remotes::install_github("SciViews/learnitdown@v1.5.2")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2023/files/learnitdown_1.5.2.tar.gz")

#remotes::install_github("jalvesaq/colorout@1.2-1")
#remotes::install_github("datacamp/testwhat@v4.11.3")
#remotes::install_github("gadenbuie/regexplain@v0.2.2")
#remotes::install_github("lbusett/insert_table@v0.4.0")
#remotes::install_github("r-lib/revdepcheck@db-2.0.0")
#remotes::install_github("r-lib/itdepends@f8d012b")

# More useful package not used in the courses (not installed, just a reminder)
#install.packages(c("abind", "agricolae", "akima", "archivist",
#  "archivist.github", "arkdb", "argon2", "attachment", "attempt", "babynames",
#  "binb", "bitops", "blogdown", "bmp", "broom.helpers","callr", "captioner",
#  "checkmate", "clock", "colourpicker", "crosstable", "ctv", ,"DataExplorer",
#  "datapackage.r", "data.validator", "digest", "distill", "distr6", "duckdb",
#  "emayili", "ensurer", "equatags", "errors", "exams", "extraDistr", "fastai",
#  "fauxpas", "fda", "filehash", "filehashSQLite", "filelock", "flashlight",
#  "flextable", "formula.tools", "fst", "ftExtra", "gapminder", "gargle",
#  "gert", "ggdist", "ggfocus", "ggforce", "ggfun", "gggap", "ggimage", "gglm",
#  "ggmosaic", "ggparty", "ggRandomForests", "ggstatsplot", "ggtext", "ggtrace",
#  "ggVennDiagram", "ggwordcloud", "gistr", "goodpractice", "googledrive", "gt",
#  "gtsummary", "igraph", "hexSticker", "hms", "htmlTable", "huxtable",
#  "import", "infer", "ipred", "ivreg", "jpeg", "jsonlite", "jsontools",
#  "kableExtra", "keras", "labelled", "Lahman", "latex2exp", "leafem", "leaps",
#  "listcomp", "lmtest", "logger", "luz", "matrixStats", "Metrics",
#  "MetricsWeighted", "mlflow", "mockery", "modelsummary", "moderndive",
#  "monaco", "needs", "nortest", "nycflights13", "officedown", "officer",
#  "opencpu", "operator.tools", "oysteR", "pacman", "parsedate", "parsermd",
#  "PERMANOVA", "posterdown", "plumber", "png", "pointblank", "prettyunits",
#  "quantities", "quickcheck", "r3js", "R62S3", "RANN", "rayshader",
#  "RcppExamples", "Rd2roxygen", "remoter", "repr", "rio", "rocker",
#  "rpart.plot", "rstatix", "rvest", "rvg", "sass", "seasonal", "seasonalview",
#  "see", "settings", "shinybusy", "shinydisconnect", "sos", "stargazer",
#  "stlplus", "survminer", "svDialogs", "svDialogstcltk", "svGUI", "svSweave",
#  "tab", "tables", "tabnet", "tableschema.r", "tactile", "tcltk2",
#  "tensorflow", "tester", "texreg", "tidycat", "tidylog", "tiff", "timevis",
#  "titanic", "torch", "torchvision", "trackdown", "urltools", "validate",
#  "validatedb", "varSelRF", "x13binary", "xgboost", "yaImpute",
#  "zip", "ztable"), Ncpus = Ncpus)

# More items for 2023 (note: littler and unix not availalbe for Windows):
install.packages(c(#"aws.s3", "aws.signature",
  "babynames", "bdsmatrix",
  "colourpicker", "cols4all", "colorblindcheck", "compareGroups", "coop", #"docopt",
  "downloader", "dtts", "equatags", "fasttime", "finalfit",
  "flashlight", "forge", "fst", "ggdark", "ggforce", "ggmap", "ggpath",
  "ggtext", "ggThemeAssist", "ghapps", "groundhog", "kit", "languageserver", #"littler",
  "octopus", "optimx", "parallelDist", "parsermd", "qs", "quartets",
  "r2d3", "RCurl", "RgoogleMaps", "roll", "rrapply", "santoku",
  "shinyDatetimePickers", "shinyFeedback", "shinytest2", "shinythemes", "spdl",
  "tiff", "tsbox", "unix"),
  Ncpus = Ncpus)

# On Mac Intel, I got errors to compile parallelDist and roll because of missing gfortran!
# I had to install gfortran-12.2-universal.pkg from CRAN -> MacOS -> tools
# On Windows, i also got en error to install parallelDist. I had to install rtools43

# More packages
tinytex::install_tinytex() # Cancel if a LaTeX distribution already exists
# Check Quarto/R Markdown html, pdf & docx, check presentations Beamer, ioslide, slidy & Powerpoint -> OK

# Not in SaturnCloud !
#Sys.setenv(NOT_CRAN = "true")
#install.packages("polars", repos = "https://rpolars.r-universe.dev")
#install.packages("polarssql", repos = c("https://rpolars.r-universe.dev", getOption("repos")))
#install.packages("tidypolars", repos = c("https://etiennebacher.r-universe.dev", getOption("repos")))

# Compare with svbox2023:
ip2024 <- installed.packages()
ip2024names <- rownames(ip2024)
# On Saturn Cloud svbox2023, do this:
#ip2023 <- installed.packages()
#cat(rownames(ip2023), sep = '", "') # Copy-paste the output here under and adapt:
ip2023names <- c(
  # User library
  "BioDataScience", "BioDataScience1", "BioDataScience2", "BioDataScience3", "modelit",

  # SciViews complements
  "abind", "ade4", "anytime", "ape", "AsioHeaders", "assert", "assertthat", "attempt",
  "aurelhy", "automap", "available", "babynames", "base64url", "bdsmatrix", "bench", "BH", "bibtex",
  "BiocGenerics", "BiocManager", "BiocVersion", "bitops", "blastula", "bookdown", "broom.mixed",
  "bundle", "butcher", "ca", "car", "carData", "caTools", "chart", "checkmate", "chromote", "chron",
  "circlize", "circular", "classInt", "clisymbols", "clock", "clue", "coda", "coin", "collapse",
  "colorblindcheck", "colourpicker", "cols4all", "compareGroups", "ComplexHeatmap", "config", "convertr",
  "coop", "coro", "corrplot", "corrr", "covr", "cowplot", "crosstalk", "crul", "cyclocomp", "cyphr",
  "data.io", "datamods", "datasauRus", "dbscan", "debugme", "deldir", "dendextend", "diagram",
  "DiagrammeR", "dials", "DiceDesign", "dichromat", "discrim", "distributional", "distributions3",
  "dm", "doFuture", "doParallel", "doRNG", "downloader", "DT", "dtts", "duckdb", "e1071", "egg",
  "ellipse", "emmeans", "entropy", "equatags", "equatiomatic", "esquisse", "estimability", "exploreit",
  "fabletools", "factoextra", "FactoMineR", "faraway", "fastcluster", "fasttime", "feasts", "filelock",
  "finalfit", "flashClust", "flashlight", "flexdashboard", "flextable", "flipdownr", "FNN",
  "fontBitstreamVera", "fontLiberation", "fontquiver", "foreach", "forge", "formatR", "Formula",
  "fortunes", "fst", "fstcore", "furrr", "future", "future.apply", "future.callr", "gclus", "gdtools",
  "geojsonsf", "geometries", "GetoptLong", "getPass", "gfonts", "GGally", "gganimate", "ggcorrplot",
  "ggdark", "ggdendro", "ggExtra", "ggforce", "ggformula", "ggfortify", "ggiraph", "ggmap", "ggpackets",
  "ggpath", "ggplotify", "ggpubr", "ggrepel", "ggridges", "ggsci", "ggsignif", "ggsn", "ggsom", "ggstance",
  "ggtext", "ggThemeAssist", "ghapps", "ghclass", "glmnet", "GlobalOptions", "globals", "golem", "gower",
  "GPfit", "gplots", "gradethis", "graph", "gridBase", "gridExtra", "gridGraphics", "gridtext", "groundhog",
  "gstat", "gtools", "hardhat", "HardyWeinberg", "HistData", "Hmisc", "htmlTable", "httpcode", "hunspell",
  "igraph", "infer", "inferit", "influenceR", "inline", "interp", "intervals", "ipred", "IRanges",
  "iterators", "janeaustenr", "janitor", "job", "jose", "jpeg", "jsonify", "kableExtra", "katex",
  "kernlab", "keyring", "kit", "kknn", "knitcitations", "kohonen", "labelled", "later", "latticeExtra",
  "lava", "lazyeval", "leafem", "leaflet", "leaflet.extras", "leaflet.providers", "leafpm", "leafpop",
  "leafsync", "leaps", "learnitdown", "learnr", "lhs", "libcoin", "LiblineaR", "lindia", "lintr", "listenv",
  "lme4", "lmerTest", "lobstr", "locfit", "lpSolve", "lwgeom", "magick", "mapedit", "maps", "mapsf",
  "maptools", "mapview", "MatrixModels", "matrixStats", "memoise", "MetricsWeighted", "mice",
  "microbenchmark", "miniCRAN", "minqa", "mlbench", "mlearning", "modeldata", "modelenv", "modelit",
  "modeltools", "mongolite", "mosaic", "mosaicCore", "mosaicData", "multcomp", "multcompView", "mvtnorm",
  "naniar", "nanotime", "nloptr", "norm", "nparcomp", "numDeriv", "nycflights13", "octopus", "officer",
  "openxlsx", "optimx", "packrat", "pagedown", "pak", "palmerpenguins", "pander", "parallelDist",
  "parallelly", "parsedate", "parsermd", "parsnip", "pastecs", "patchwork", "pbkrtest", "permute",
  "phosphoricons", "piggyback", "pingr", "pins", "pixmap", "pkgcache", "pkgdepends", "PKI", "plogr",
  "plotly", "plyr", "png", "polyclip", "polynom", "prettyglm", "printr", "pROC", "prodlim", "profmem",
  "progressr", "proto", "proxy", "pryr", "pwr", "qap", "qs", "quadprog", "quantmod", "quantreg", "quartets",
  "quarto", "questionr", "R.cache", "R.methodsS3", "R.oo", "R.utils", "r2d3", "randomForest", "ranger",
  "rapidjsonr", "rapidoc", "RApiSerialize", "rapportools", "raster", "RColorBrewer", "RcppArmadillo",
  "RcppCCTZ", "RcppDate", "RcppEigen", "RcppParallel", "RcppSpdlog", "rcrossref", "RCurl", "reactable",
  "reactlog", "reactR", "recipes", "RefManageR", "registry", "renv", "repr", "reshape", "reshape2", "rex",
  "rgl", "RgoogleMaps", "Rgraphviz", "RhpcBLASctl", "rhub", "rio", "rjson", "rmdformats", "rngtools", "ROCR",
  "roll", "rpart.plot", "rrapply", "rsample", "rsconnect", "Rsolnp", "RSQLite", "rstatix", "rticles", "s2",
  "S4Vectors", "S7", "sandwich", "santoku", "satellite", "scatterplot3d", "SciViews", "seriation", "servr",
  "sf", "sfheaders", "sftime", "shape", "shinyAce", "shinybusy", "shinydashboard", "shinyDatetimePickers",
  "shinyFeedback", "shinyjs", "shinylogs", "shinytest", "shinytest2", "shinythemes", "shinytoastr",
  "shinyWidgets", "showimage", "skimr", "slider", "sloop", "smotefamily", "snakecase", "SnowballC",
  "sodium", "sortable", "sp", "spacesXYZ", "spacetime", "SparseM", "spData", "spdl", "spelling", "SQUAREM",
  "stars", "stringdist", "stringfish", "styler", "summarytools", "suppdata", "SuppDists", "svBase", "svFlow",
  "svglite", "svMisc", "svUnit", "tabularise", "targets", "terra", "TH.data", "thematic", "tictoc", "tidycat",
  "tidymodels", "tidytext", "tiff", "timechange", "timeDate", "tinytest", "tmap", "tmaptools", "todor",
  "tokenizers", "transformr", "triebeard", "truncnorm", "TSA", "tsbox", "tseries", "tsibble", "TSP", "TTR",
  "tune", "tweenr", "units", "unix", "UpSetR", "urltools", "UsingR", "V8", "vegan", "vembedr", "vetiver",
  "vip", "viridis", "visdat", "visNetwork", "warp", "webdriver", "webshot", "websocket", "whoami", "widgetframe",
  "wk", "workflows", "workflowsets", "writexl", "WriteXLS", "xaringan", "XML", "xmlparsedata", "xslt", "xts",
  "yardstick", "yesno", "yulab.utils", "zeallot", "zoo",

  # Saturn Cloud
  "askpass", "aws.s3", "aws.signature", "backports",
  "base64enc", "bit", "bit64", "blob", "brew", "brio", "broom", "bslib", "cachem", "callr", "cellranger", "cli",
  "clipr", "colorspace", "commonmark", "conflicted", "cpp11", "crayon", "credentials", "curl", "data.table",
  "DBI", "dbplyr", "desc", "devtools", "diffobj", "digest", "docopt", "downlit", "dplyr", "dtplyr", "ellipsis",
  "evaluate", "fansi", "farver", "fastmap", "fontawesome", "forcats", "fs", "gargle", "generics", "gert",
  "ggplot2", "gh", "gitcreds", "glue", "googledrive", "googlesheets4", "gtable", "haven", "here", "highr",
  "hms", "htmltools", "htmlwidgets", "httpuv", "httr", "httr2", "ids", "ini", "isoband", "jquerylib", "jsonlite",
  "knitr", "labeling", "later", "lifecycle", "littler", "lubridate", "magrittr", "markdown", "memoise", "mime",
  "miniUI", "modelr", "munsell", "odbc", "openssl", "pillar", "pkgbuild", "pkgconfig", "pkgdown", "pkgload",
  "png", "praise", "prettyunits", "processx", "profvis", "progress", "promises", "ps", "purrr", "R6", "ragg",
  "rappdirs", "rcmdcheck", "RColorBrewer", "Rcpp", "RcppTOML", "readr", "readxl", "rematch", "rematch2",
  "remotes", "reprex", "reticulate", "rlang", "rmarkdown", "roxygen2", "rprojroot", "rstudioapi", "rversions",
  "rvest", "sass", "scales", "selectr", "sessioninfo", "shiny", "sourcetools", "stringi", "stringr", "sys",
  "systemfonts", "testthat", "textshaping", "tibble", "tidyr", "tidyselect", "tidyverse", "timechange",
  "tinytex", "tzdb", "urlchecker", "usethis", "utf8", "uuid", "vctrs", "viridisLite", "vroom", "waldo", "whisker",
  "withr", "xfun", "xml2", "xopen", "xtable", "yaml", "zip",

  # Base and recommended
  "base", "boot", "class", "cluster", "codetools", "compiler", "datasets", "foreign", "graphics", "grDevices",
  "grid", "KernSmooth", "lattice", "MASS", "Matrix", "methods", "mgcv", "nlme", "nnet", "parallel", "rpart",
  "spatial", "splines", "stats", "stats4", "survival", "tcltk", "tools", "utils")

# Missing items from 2023:
ip2023names[!ip2023names %in% ip2024names]
# ggstance: now its features are integrated in ggplot2
# ggsn, maptools archived, ggsn replaced by ggspatial in 2024
# influenceR: calculate nodes statistics in a graph -> no
# openxlsx: read/write Excel files, but we use readxl, WriteXLS and write_xlsx instead -> not needed

# New items:
ip2024names[!ip2024names %in% ip2023names]
# ggstats is new import for GGally -> itself imports broom.helpers
# cereal is a new import for vetiver
# collections is a new import for languageserver (and duckplyr in 2024)
# ggdist is a new import for fabletools
# mitml is a new import of mice -> itself importing jomo and pan, and jomo needs ordinal that itself needs ucminf
# maplegend is a new import for mapsf
# pracma is an import for a large number of other packages
# rosm import for ggspatial
# secretbase import for target
# esquisse imports datamods that itself imports toastui
# on Windows, I got translations too

# More items for 2024:
install.packages(c("atime", "connectapi", "correctR", "correlationfunnel", "cv",
  "dqrng",  #"downlit",
  "duckdbfs", "duckplyr", "fixest", "ggeffects", "ggpmisc",
  "ggpp", "ggraph", "ggspatial", "GLMsData", #"httr2",
  "lterdatasampler",
  "modeldata", "modeldatatoo", "poorman", "reactable", "reactable.extras",
  "searcher", #"see" No, because too many dependencies!
  "servr", "table1", "this.path", "tidyfast", "tinytable", "xgboost"),
  Ncpus = Ncpus)

# From the learnitr universe:
install.packages(c('learnr', 'shinytest2'))
remotes::install_github(c('rstudio/gradethis@v0.2.14'), upgrade = 'never')

install.packages(c("ggcheck", "learnitdown", "learnitgrid",
  "learnitprogress", "learnitdashboard"), repos =
    c(learnitr = "https://learnitr.r-universe.dev", CRAN = repos["CRAN"]))

# Restore options
options(repos = orepos)
options(install.packages.check.source = NULL)

# Now, check if the packages that need compilation at least load correctly
ip <- as.data.frame(installed.packages())
cip <- ip[ip$NeedsCompilation == "yes", ]
nrow(cip) # 283 on Mac, 282 on Windows, 301 on SaturnCloud
cip_error <- character(0)
for (cipak in na.omit(cip$Package)) {
  res <- try(library(cipak, character.only = TRUE), silent = FALSE)
  if (inherits(res, "try-error")) {
    cip_error <- c(cip_error, cipak)
  } else {
    try(detach(paste0("package:", cipak), character.only = TRUE, unload = TRUE),
      silent = TRUE)
  }
}
print(cip_error) # On SaturnCloud, I got errors for tcltk because tcltk.so is not found

# Once this is done, stop and edit the machine:
#
# In environment variables:
#LANG=fr_FR.UTF-8
#R_LIBS=/usr/local/lib/R/sciviews-library:/usr/local/lib/R/site-library:/usr/local/lib/R/library
#TIMEOUT=60
#
# In start script:
if [[ $LANG != en* ]]; then
echo "Adding locale $LANG..."
sudo locale-gen $LANG
sudo update-locale
fi

echo "Writing config file ${R_HOME}/etc/Rprofile.site..."
cat >tmp.site <<EOL
options(repos = c(
  SciViews = 'https://sciviews.r-universe.dev',
  CRAN     = 'https://packagemanager.posit.co/cran/__linux__/jammy/2024-04-20'))
# Set user-agent from https://docs.rstudio.com/rspm/1.1.2/admin/binaries.html
options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(
  getRversion(), R.version$platform, R.version$arch, R.version$os)))
# Make sure there is no working-dir.sh file in /etc/profile.d
try(system("sudo rm -f /etc/profile.d/working-dir.sh"), silent = TRUE)
# Make sure the personal lib, then the SciViews lib are on .libPaths()
.libPaths(c("/home/jovyan/R/x86_64-pc-linux-gnu-library/4.3",
  "/usr/local/lib/R/sciviews-library"))

# The temp environment
.temp_env <- (function() {
  pos <- match("SciViews:TempEnv", search())
  if (is.na(pos)) {
    tmp <- list()
    attach_env <- function(...) get("attach", mode = "function")(...)
    attach_env(tmp, name = "SciViews:TempEnv", pos = length(search()) - 1L)
    rm(tmp)
    pos <- match("SciViews:TempEnv", search())
  }
  pos.to.env(pos)
})()

# Install an activity tracker to stop the SaturnCloud machine after a timeout
assign('saturn_timeout', function(timeout_min = NULL, verbose = TRUE) {
  if (!missing(timeout_min)) {
    stopifnot(is.numeric(timeout_min), length(timeout_min) == 1)
    timeout_min <- as.integer(timeout_min)
    writeLines(as.character(timeout_min), "/home/jovyan/.timeout")
  } else {# Get current value
    timeout_min <- readLines("/home/jovyan/.timeout")[1]
    timeout_min <- try(as.numeric(timeout_min), silent = TRUE)
    if (inherits(timeout_min, "try-error")) {
      # Use default value
      timeout_min <- Sys.getenv("TIMEOUT", unset = "60")
      timeout_min <- try(as.numeric(timeout_min), silent = TRUE)
      if (inherits(timeout_min, "try-error")) {
        Sys.setenv(TIMEOUT = "60")
        timeout_min <- 60
      }
      # Since the timeout was wrong, we reset it
      writeLines(as.character(timeout_min), "/home/jovyan/.timeout")
    }
  }
  # Set the time out
  if (isTRUE(verbose)) {
    msg <- paste("SaturnCloud time out is now", timeout_min, "minutes.")
    timeout_def <- Sys.getenv("TIMEOUT", unset = "60")
    timeout_def <- try(as.numeric(timeout_def), silent = TRUE)
    if (inherits(timeout_def, "try-error"))
      timeout_def <- 60
    if (timeout_min < timeout_def)
      msg <- paste(msg, "It will be reset to", timeout_def,
        "minutes next time.")
    message(msg)
  }
  fs::file_touch("/home/jovyan/.timeout", Sys.time() + timeout_min * 60)
  invisible(timeout_min)
}, envir = .temp_env)
saturn_timeout(verbose = FALSE)

assign('.set_prompt', function(expr, value, succeeded, visible) {
  timeout_min <- saturn_timeout(verbose = FALSE)
  timeout_def <- Sys.getenv("TIMEOUT", unset = "60")
  timeout_def <- try(as.numeric(timeout_def), silent = TRUE)
  if (inherits(timeout_def, "try-error")) {
    Sys.setenv(TIMEOUT = "60")
    timeout_def <- 60
  }
  # Only display timeout if it differs from the default
  if (timeout_min == timeout_def) {
    timeout_msg <- ""
  } else {
    timeout_msg <- paste0("[", timeout_min, "min] ")
  }
  branch <- try(gert::git_branch(), silent = TRUE)
  if (inherits(branch, "try-error")) {
    # Either not a git repo or gert is not installed (2nd is unlikely)
    options(prompt = paste0(timeout_msg, "> "))
  } else {
    to_commit <- NROW(gert::git_status()) != 0
    if (to_commit) {
      options(prompt = paste0(timeout_msg, branch, "* > "))
    } else {
      options(prompt = paste0(timeout_msg, branch, " > "))
    }
  }
  # Make sure timeouts <= timeout_def are transients
  if (timeout_min < timeout_def) {
    writeLines(as.character(timeout_def), "/home/jovyan/.timeout")
    fs::file_touch("/home/jovyan/.timeout", Sys.time() + timeout_min * 60)
  }
  TRUE
}, envir = .temp_env)
invisible(addTaskCallback(.set_prompt, name = "saturn_track_activity"))
# Change the prompt right now
invisible(.set_prompt())

# Reset timeout on activity, that is: save a file or knit a document
later::later(function() {
  if (rstudioapi::isAvailable() &&
      !exists('.handle_saveSourceDoc', envir = .temp_env, inherits = FALSE)) {
    assign('.handle_saveSourceDoc',
      rstudioapi::registerCommandCallback("saveSourceDoc",
        function() saturn_timeout(verbose = FALSE)),
      envir = .temp_env)
  }
}, 5)

later::later(function() {
  if (rstudioapi::isAvailable() &&
      !exists('.handle_knitDocument', envir = .temp_env, inherits = FALSE)) {
    assign('.handle_knitDocument',
      rstudioapi::registerCommandCallback("knitDocument",
        function() saturn_timeout(verbose = FALSE)),
      envir = .temp_env)
  }
}, 5)

# Warn for commit after deadline (and reset timeout on committing)
assign('.commit_warn', function() {
  saturn_timeout(verbose = FALSE)
  # This works at the console, but not in a taskCallback (why?)
  #if ("origin/final" %in% gert::git_branch_list(FALSE, repo = getwd())$name)
  # Replaced by this:
  project_dir <- try(rstudioapi::getActiveProject(), silent = TRUE)
  if (inherits(project_dir, "try-error") || is.null(project_dir))
    return()
  odir <- setwd(project_dir)
  on.exit(setwd(odir))
  is_final <- try(any("origin/final" == trimws(system("git branch -r",
    intern = TRUE))), silent = TRUE)
  if (!inherits(is_final, "try-error") && is_final)
    rstudioapi::showDialog("Science des donn\u00e9es biologiques",
      paste0("<b>Attention:</b> le commit est r\u00e9alis\u00e9 ",
        "apr\u00e8s la deadline du projet et ne sera pas pris en ",
        "compte dans l'\u00e9valuation ! <i>Soyez plus attentif ",
        "\u00e0 respecter le calendrier \u00e0 l'avenir.</i>"))
}, envir = .temp_env)

# Check that the project is a BioDataScience-Course repo
assign('.test_wrong_project', (function() {
  is_admin <- FALSE
  function(status = FALSE) {
    if (!rstudioapi::isAvailable())
      return(invisible(NA))
    if (isTRUE(status))
      return(is_admin)
    if (is_admin)
      return(invisible(FALSE))
    repo <- try(gert::git_remote_info("origin")$url, silent = TRUE)
    if (!inherits(repo, "try-error")) {
      res <- try(grepl("BioDataScience-Course",
        repo, fixed = TRUE), silent = TRUE)
    } else {
      return(invisible(FALSE)) # No repo, deal files individually in .test_doc()
    }
    if (!inherits(res, "try-error") && all(res == FALSE)) {
      pass <- rstudioapi::askForPassword(
        paste0("Le projet que vous avez ouvert ne fait pas partie de ",
          "l'organisation GitHub BioDataScience-Course. Vous ne pouvez ",
          "pas y travailler dans la machine d\u00e9di\u00e9e au cours. ",
          "Il va \u00eatre ferm\u00e9 \u00e0 pr\u00e9sent. Rouvrez-le dans ",
          "une machine de votre compte personnel ou entrez le mot de passe."))
      if (digest::digest(pass) != "cfe7383614aacd5035642bf60d7d1a3e") {
        rstudioapi::executeCommand('closeProject')
        later::later(.test_wrong_project, 5)
        invisible(TRUE)
      } else {
        # Record the admin status for this session
        is_admin <<- TRUE
        invisible(FALSE)
      }
    } else {
      # This is a BioDataScience-Course project, or not bound to GitHub
      # Make sure a handle for a message for commit after deadline is installed
      if (!exists('.handle_vscCommit', envir = .temp_env, inherits = FALSE)) {
        assign('.handle_vcsCommit',
          rstudioapi::registerCommandCallback("vcsCommit", .commit_warn),
          envir = .temp_env)
      }
      invisible(FALSE)
    }
  }
})(), envir = .temp_env)
# Inactivated for now
#later::later(function()
#  if (rstudioapi::isAvailable()) .test_wrong_project(), 10)

# Check the currently edited document
# If it is outside the repo & not in a BioDataScience-Course project -> nag
# otherwise (outside only) display a one time message
assign('.test_doc', function() {
  if (!rstudioapi::isAvailable())
    return()
  # Check if timeout is close (note, display warning only once)
  timeout <- file.mtime("/home/jovyan/.timeout")
  cur_time_5min <- Sys.time() + 5 * 60
  will_stop_5min <- try(cur_time_5min > timeout - 5 &&
      cur_time_5min <= timeout + 5, silent = TRUE)
  if (isTRUE(will_stop_5min)) {
    rstudioapi::showDialog("Machine consid\u00e9r\u00e9e inactive",
      paste0("<b>Attention:</b> sans r\u00e9action de votre part, la machine ",
        "va bient\u00f4t s'\u00e9teindre automatiquement. Souhaitez-vous ",
        "la maintenir active <i>(cliquez OK) ?</i>"))
    saturn_timeout(verbose = FALSE)
  }

  later::later(.test_doc, 10)
  return()

  # The rest is NOT run (don't check anymore if in BioDataScience-Course)
  # If we are admin, no problems
  if (.test_wrong_project(status = TRUE)) {
    later::later(.test_doc, 10)
    return()
  }
  if (!is.null(rstudioapi::documentId(FALSE))) {
    path <- try(rstudioapi::documentPath(), silent = TRUE)
    # If the document is not saved, I got an error! -> consider the doc is OK
    if (inherits(path, "try-error")) {
      is_sdd <- TRUE
    } else {
      # Check that the edited document is in a BioDataScience-Course repo
      repo <- try(gert::git_remote_list(dirname(path))$url, silent = TRUE)
      if (!inherits(repo, "try-error")) {
        is_sdd <- try(grepl("BioDataScience-Course",
          repo, fixed = TRUE), silent = TRUE)
        if (inherits(is_sdd, "try-error"))
          is_sdd <- FALSE
      } else {
        is_sdd <- FALSE
      }
      if (!length(is_sdd)) is_sdd <- FALSE
    }
    if (!any(is_sdd))
      rstudioapi::showDialog("Science des donn\u00e9es biologiques",
        paste0("<b>Attention:</b> vous \u00e9ditez un fichier qui ",
          "n'appartient pas \u00e0 un projet du cours. Si le fichier n'est ",
          "pas encore enregistr\u00e9, sauvegardez-le maintenant dans un ",
          "projet SDD. Vous ne <i>pouvez pas</i> utiliser cette ",
          "machine pour du travail hors du cours SDD. Utilisez une machine ",
          "sur votre compte personnel SaturnCloud pour cela. ",
          "\n\n<i>(message affich\u00e9 toutes les 10 sec.)</i>"))
  }
  later::later(.test_doc, 10)
}, envir = .temp_env)
later::later(function() if (rstudioapi::isAvailable()) .test_doc(), 12)

# Function to kill the virtual machine from within R
assign('.saturn_cloud_shutdown', function() {
  message("Shutting down the SaturnCloud machine (you have to restart it to continue using it)...")
  saturn_timeout(0, verbose = FALSE)
}, envir = .temp_env)
# Hook it up to quitSession
later::later(function() {
  if (rstudioapi::isAvailable() &&
      !exists('.handle_quitSession', envir = .temp_env, inherits = FALSE)) {
    assign('.handle_quitSession',
      rstudioapi::registerCommandCallback("quitSession", .saturn_cloud_shutdown),
      envir = .temp_env)
  }
}, 5)

# Do we want R in another language?
if (Sys.getenv("LANG", unset = "en") != "en")
  try(Sys.setLanguage(Sys.getenv("LANG")), silent = TRUE)

# Keep a permanent track of our temporary environment... in itself
.temp_env$.temp_env <- .temp_env
rm(.temp_env)
EOL

R_HOME=$(Rscript --vanilla -e "cat(Sys.getenv('R_HOME'))")
RPROFILE_LOCATION=${R_HOME}/etc/Rprofile.site
# If an alternate Rprofile.site file is provided, use it instead
if [ -f ~/shared/svbox2024/.config/Rprofile.site ]; then
sudo cp ~/shared/svbox2024/.config/Rprofile.site ${RPROFILE_LOCATION}
rm tmp.site
else
  sudo mv tmp.site ${RPROFILE_LOCATION}
fi
sudo rm -f /etc/R/Rprofile.site

echo "Configuring git (pull rebase -> false)..."
# TODO: set email from EMAIL if provided?
git config --global pull.rebase false

echo "Installing SciViews and user libraries for R..."
mkdir -p /home/jovyan/R/x86_64-pc-linux-gnu-library/4.3
sudo mkdir -p /usr/local/lib/R/sciviews-library
sudo chown -R jovyan:jovyan /usr/local/lib/R/sciviews-library
# Only for plain svbox2024
#if [ ! -d ~/shared/svbox2024/.R/library/4.3 ]; then
#  echo "Downloading and installing R packages for SciViews..."
#  mkdir -p ~/shared/svbox2024/.R/library
#  cd ~/shared/svbox2024/.R/library
#  curl -o ~/shared/svbox2024/.R/library/packages.tar.xz "https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/svbox2024-saturn-packages.tar.xz"
#  tar -xf ~/shared/svbox2024/.R/library/packages.tar.xz
#  rm ~/shared/svbox2024/.R/library/packages.tar.xz
#  cd -
#fi
echo "Linking R packages for SciViews..."
if [ -d ~/shared/svbox2024/.R/library/4.3 ]; then
sudo ln -s /home/jovyan/shared/svbox2024/.R/library/4.3/* /usr/local/lib/R/sciviews-library
fi

echo "Configuring RStudio..."
if [ ! -f /home/jovyan/.config/rstudio/dictionaries/languages-system/fr_FR.dic ]; then
mkdir -p /home/jovyan/.config/rstudio/dictionaries/languages-system
cd /home/jovyan/.config/rstudio/dictionaries/languages-system
curl -o fr_dic.tar.gz "https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/fr_dic.tar.gz"
tar xf fr_dic.tar.gz
rm -rf ._* # Just in case there are such files... (e.g., when compressed in macOS)
  rm fr_dic.tar.gz
cd -
  fi
if [ ! -f /home/jovyan/.config/rstudio/snippets/r.snippets ]; then
mkdir -p /home/jovyan/.config/rstudio/snippets
if [[ $LANG = fr* ]]; then
curl -o /home/jovyan/.config/rstudio/rstudio-prefs.json "https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/rstudio-prefs-fr.json"
else
  curl -o /home/jovyan/.config/rstudio/rstudio-prefs.json "https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/rstudio-prefs.json"
fi
curl -o /home/jovyan/.config/rstudio/snippets/r.snippets "https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/r.snippets"
fi
# Make extra fonts available to RStudio
sudo ln -s /usr/share/fonts/truetype/firacode /etc/rstudio/fonts/FiraCode
export SDD_PASSWORD_2024=$(Rscript -e "cat(learnitdown::encrypt(Sys.getenv('SDD_PASSWORD_2024'), Sys.getenv('SATURN_TOKEN'), base64 = TRUE, url.encode = TRUE))")

echo "Installing tinytex files..."
if [ ! -d /home/jovyan/.TinyTeX ]; then
if [ -f /home/jovyan/shared/svbox2024/.config/tinytex.tar.gz ]; then
cp /home/jovyan/shared/svbox2024/.config/tinytex.tar.gz /home/jovyan/tinytex.tar.gz
else
  curl -o /home/jovyan/tinytex.tar.gz "https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/tinytex.tar.gz"
fi
cd /home/jovyan
tar xf tinytex.tar.gz
rm tinytex.tar.gz
mkdir -p /home/jovyan/.local/bin
ln -sf /home/jovyan/.TinyTeX/bin/x86_64-linux/* /home/jovyan/.local/bin
cd -
  fi

echo "Installing an activity timeout checker..."
[ -n "$TIMEOUT" ] || export TIMEOUT=60
echo "$TIMEOUT" > /home/jovyan/.timeout
if [ ! -f /etc/profile.d/sciviews.sh ]; then
cat >tmp.sh <<EOL
function saturn_timeout() {
  if [ -z "\$1" ]; then
  # No new timeout provided
  timeout_min=\$(cat /home/jovyan/.timeout)
  else
    # A new number is provided
    if [[ \$1 =~ ^[0-9]+\$ ]]; then
  timeout_min=\$1
  echo "\$1" > /home/jovyan/.timeout
  else
    echo "Error: timeout is not a nul or positive integer"
  return 1
  fi
  fi
  echo "SaturnCloud time out is now \${timeout_min} minutes."
  touch /home/jovyan/.timeout -d"\${timeout_min}min"
}
export -f saturn_timeout

PROMPT_COMMAND='touch /home/jovyan/.timeout -d"+\$(cat /home/jovyan/.timeout)min" &>/dev/null;echo -ne "\033]0;\${PWD/#\${HOME}/~} - \${SATURN_USER}@\${SATURN_PROJECT_NAME}\007\e[0;35m"'
PS0='\$(touch /home/jovyan/.timeout -d"+\$(cat /home/jovyan/.timeout)min" &>/dev/null)\e[0m'
PS1='[\$(cat /home/jovyan/.timeout)min]\
\$(git branch &>/dev/null; if [ \$? -eq 0 ]; then \
echo " \$(git branch | grep ^* | sed s/\*\ //)\
\$(echo \`git status\` | grep "nothing to commit" > /dev/null 2>&1; if [ "\$?" -ne "0" ]; then \
echo "* \\\$ "; else echo " \\\$ "; fi)"; else echo " \\\$ "; fi)'
touch /home/jovyan/.timeout -d"+\$(cat /home/jovyan/.timeout)min" &>/dev/null
echo -ne "\033]0;\${PWD/#${HOME}/~} - \${SATURN_USER}@\${SATURN_PROJECT_NAME}\007\e[0;35m"
EOL

# Note unreadable for the Vibrant Ink and Idle Fingers RStudio themes
# but OK for the other themes
sudo mv tmp.sh /etc/profile.d/sciviews.sh
fi
# Also inactivate the forcing to workspace as initial dir
#if [ -f /etc/profile.d/working-dir.sh ]; then
sudo rm -f /etc/profile.d/working-dir.sh
#sudo touch /etc/profile.d/working-dir.sh
#fi

cat >tmp.sh <<EOL
#!/bin/sh

[ -n "\$TIMEOUT" ] || export TIMEOUT=60

while sleep 1m; do
if [ ! -f /home/jovyan/.timeout ]; then
echo "\$TIMEOUT" > /home/jovyan/.timeout
touch /home/jovyan/.timeout -d"\$TIMEOUT+min"
fi
touch /home/jovyan/.timeout_check
if [ /home/jovyan/.timeout -ot /home/jovyan/.timeout_check ]; then
echo "Closing the machine with $BASE_URL/api/jupyter_servers/$(echo $HOSTNAME | awk -F'-' '{print $4}')/stop"
curl -s -X POST -H "Authorization: token $SATURN_TOKEN" "$BASE_URL/api/jupyter_servers/$(echo $HOSTNAME | awk -F'-' '{print $4}')/stop"
fi
done
EOL

sudo mv tmp.sh /home/jovyan/.local/bin/check_timeout
sudo chmod +x /home/jovyan/.local/bin/check_timeout
/home/jovyan/.local/bin/check_timeout &

  echo "BioDataScience install..."
mkdir -p /home/jovyan/.config/R
curl -o /home/jovyan/.config/R/BioDataScience.R 'https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/BioDataScience.R'
Rscript -e "source('/home/jovyan/.config/R/BioDataScience.R')"

#
# Subdomain: svbox2024sdd-<login>
#
# Then in secret and roles:
# - First add sdd/sdd-password-2024 and create SDD_PASSWORD_2024 using it with desc:
# Password to record its activity in Biological Data Science Courses at UMONS - provided by the teacher (academic year 2024-2025)
# - Add <user>/connect-api-key and create CONNECT_API_KEY with desc:
# API key for Posit Connect
# - Add sdd/sciviews-chatbot-url with https://sdd.umons.ac.be/chatbot/chat and create SCIVIEWS_CHATBOT_URL with desc:
# URL for the SDD course chatbot
# - Create EMAIL and possibly attach email from perso
# Institutional email like XXXXXX@umons.ac.be with XXXXXX, your UMONS id (not needed if it is the same as your SaturnCloud email).
# - Create NAME with no secret
# Student name as 'Firstname_Lastname' in case it cannot be guessed from the login.
# - Create SDD_USER_2024 with no secret
# Crypted string with the student identity and role copied from https://wp.sciviews.org/saturncloud_user_config.html?configure=1
#
# Test the machine...
#
# Then in Manage -> Share Resource
# Link is:
# [![Run in Saturn Cloud](https://saturncloud.io/images/embed/run-in-saturn-cloud.svg)](https://app.community.saturnenterprise.io/dash/o/EcoNum/resources?templateId=a2f2607eec7a4b0c8b3adee7caa7471b)




# Mac: There are 693 packages in sciviews-library, 1.61Gb on disk on arm64, 1.51Gb on x86_64
# Windows: There are 690 packages in C:/Users/<username>/AppData/Local/R/win-library/4.3, 1.70Gb on disk

# Once it is done, rename library into sciviews-library and do
#XZ_OPT=-e9T0 tar cJvf sciviews-library2024_<os>_<ver>.tar.xz sciviews-library
# but uses only one core -> tar first, then xz.
#
# For Mac silicon:
#cd ~/Library/R/arm64/4.3
#tar cvf sciviews-library2024_mac_arm64.tar sciviews-library
#xz -z -9 -e -T0 -v sciviews-library2024_mac_arm64.tar
# Once compressed, it makes 626Mb for _mac_arm64
#
# For Mac Intel:
# cd ~/Library/R/x86_64/4.3 or
#tar cvf sciviews-library2024_mac_x86_64.tar sciviews-library
#xz -z -9 -e -T0 -v sciviews-library2024_mac_x86_64.tar
# Once compressed, it makes 671Mb for _mac_x86_64
#
# For Windows Intel
#cd C:/Users/phgro/AppData/Local/R/sciviews-library
#tar cvf sciviews-library2024_win_x86_64.tar 4.3
#xz -z -9 -e -T0 -v sciviews-library2024_win_x86_64.tar
# Once compressed, it makes 684Mb for _win_x86_64

################################################################################
# Optional stuff:

# For SDD courses
# BioDataScience|1|2|3
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/BioDataScience1_2024.0.0.tar.gz")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/BioDataScience2_2024.0.0.tar.gz")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/BioDataScience3_2024.0.0.tar.gz")

#remotes::install_github(c(
#  'BioDataScience-Course/BioDataScience@v2024.0.0',
#  'BioDataScience-Course/BioDataScience1@v2024.0.0',
#  'BioDataScience-Course/BioDataScience2@v2024.0.0',
#  'BioDataScience-Course/BioDataScience3@v2024.0.0'
#), upgrade = 'always')

# TODO: install data.table and collapse with parallel computation
#
