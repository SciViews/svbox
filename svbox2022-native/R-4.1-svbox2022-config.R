# Also need to create Rprofile.site which tools changes repos["CRAN"]!
# Copy-paste the content of R-4.1-svbox2022-config.sh in a terminal for that
# after closing R and RStudio. Restart RStudio and check that getOption("repos")
# returns the right value.
orepos <- repos <- getOption("repos")
repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2022-04-21"
# For Ubuntu 20.04LTS Focal Fossa, use this instead!
#repos["CRAN"] <- "https://packagemanager.rstudio.com/cran/__linux__/focal/2022-04-21"
options(repos = repos)
options(timeout = 800) # Needed for sf and terra, increase if needed
Ncpus <- parallel::detectCores(logical = FALSE)
# If you don't want parallel install
#Ncpus <- 1L
# If there is a source package more recent than the binary, do not ask:
options(install.packages.check.source = "no")

update.packages()

# Now, we install roughly 300 packages + their dependencies...
# it makes a total of 551 package and 2.39GB on a Mac Intel.

install.packages("webshot")
webshot::install_phantomjs()

# Note: there is somewhere a dependency to terra_1.5-21 that makes 100.9MB!!!
# => try to get rid of it! Note: terra is supposed to replace raster
# sf weights 95.9MB also! (BH = 12MB)
install.packages("BH")
install.packages("sf")
install.packages("terra")
# TODO: add rpart.plot
install.packages(c("ade4", "anytime", "ape", "assert", "assertthat", "automap",
  "available", "backports", "base64enc", "base64url", "bench", "bit", "bit64",
  "blastula", "blob", "bookdown", "boot", "broom", "broom.mixed", "butcher",
  "ca", "car", "chromote", "circular", "cli", "clisymbols", "coin", "collapse",
  "config", "conflicted", "convertr", "coro", "corrplot", "corrr", "covr",
  "cowplot", "crayon", "curl", "cyphr", "data.table", "datasauRus", "DBI",
  "dbplyr", "devtools", "DiagrammeR", "dials", "digest", "discrim",
  "distributional", "distributions3", "doFuture", "doParallel", "doRNG", "dm",
  "DT", "dtplyr", "duckdb", "e1071", "egg", "ellipse", "emmeans", "esquisse",
  "evaluate", "factoextra", "FactoMineR", "fansi", "faraway", "fastcluster",
  "fastmap", "feasts", "flashClust", "flexdashboard", "flipdownr",
  "fontawesome", "forcats", "foreach", "formatR", "fortunes", "fs", "furrr",
  "future", "future.apply", "future.callr", "gdtools", "generics", "getPass",
  "GGally", "gganimate", "ggconf", "ggcorrplot", "ggdendro", "ggExtra",
  "ggfortify", "ggiraph", "ggpackets", "ggpubr", "ggrepel", "ggridges", "ggsci",
  "ggsignif", "ggsn", "ggsom", "ghclass", "gitcreds", "glmnet", "glue", "golem",
  "googlesheets4", "gridBase", "gridExtra", "gridGraphics", "gstat", "haven",
  "here", "Hmisc", "htmltools", "htmlwidgets", "httpuv", "httr", "igraph",
  "inline", "ipred", "IRkernel", "iterators", "janitor", "job", "jsonlite",
  "keyring", "kernlab", "kknn", "knitr", "knitcitations", "kohonen", "later",
  "lattice", "latticeExtra", "leaflet", "LiblineaR", "lifecycle",  "lindia",
  "lintr", "lobstr", "lme4", "lmerTest", "lubridate", "magrittr", "mapedit",
  "maps", "mapsf", "mapview", "markdown", "memoise", "microbenchmark", "mime",
  "miniCRAN", "miniUI", "mlbench", "modelr", "mongolite", "mosaic", "multcomp",
  "mvtnorm", "naniar", "nanotime", "nparcomp", "nycflights13", "odbc",
  "pagedown", "pak", "palmerpenguins", "pander", "parsnip", "patchwork",
  "piggyback", "pillar", "pins", "pkgdepends", "pkgdown", "PKI", "plotly",
  "prettyglm", "printr", "pROC", "progressr", "promises", "pryr", "purrr",
  "pwr", "quantreg", "quarto", "questionr", "R6", "ragg", "randomForest",
  "ranger", "raster", "RColorBrewer", "Rcpp", "RcppCCTZ", "reactlog", "readxl",
  "recipes", "rhub", "remotes", "reprex", "reticulate", "rgl", "RhpcBLASctl",
  "rlang", "rmarkdown", "rmdformats", "ROCR", "rpart", "rprojroot", "rsample",
  "rsconnect", "RSQLite", "rticles", "sessioninfo", "shiny", "shinydashboard",
  "shinyjs", "shinylogs", "shinytest", "shinytoastr", "shinyWidgets", "skimr",
  "slider", "sloop", "smotefamily", "sodium", "sortable", "sparklyr", "spData",
  "spelling", "stars", "stringi", "stringr", "styler", "summarytools",
  "suppdata", "SuppDists", "svglite", "svUnit", "sys", "targets", "testthat",
  "thematic", "tictoc", "tidymodels", "tidyr", "tidyverse", "tinytest", "tmap",
  "tmaptools", "todor", "transformr", "TSA", "tsibble", "tune", "usethis",
  "UsingR", "vctrs", "vegan", "vembedr", "vetiver", "vip", "viridis",
  "viridisLite", "visdat", "vroom", "waldo", "warp", "withr", "workflows",
  "workflowsets", "writexl", "WriteXLS", "xaringan", "xfun", "xtable", "xts",
  "yaml", "yardstick", "zeallot", "zoo"), Ncpus = Ncpus)

# From Bioconductor
install.packages("BiocManager")
BiocManager::install(c("graph", "ComplexHeatmap", "Rgraphviz",
  "RDRToolbox"), update = FALSE, ask = FALSE)

# Dependencies for packages installed with install_from_url()
install.packages("magick") # 37.2MB
install.packages(c("getPass", "ggplotify", "proto", "renv", "shinylogs",
  "shinytoastr", "tsibble"), Ncpus = Ncpus)

#remotes::install_github("r-lib/usethis@v2.1.6") # For v2 R CMD check GitHub actions

# For packages not on CRAN, I install from URL (note: remotes::install_github()
# or remotes::install_url() are problematic because they call GitHub API with
# limit of 60hits/hour and lead to broken RStudio when launched from JupyterHub)
install_from_url <- function(url) {
  if (file.exists("/home/rstudio")) {# In Saturn-cloud or RStudio server
    file <- file.path("/home/rstudio", basename(url))
  } else {# We assume we are in RStudio Desktop on MacOS
    file <- file.path("~/Downloads", basename(url))
  }
  on.exit(unlink(file))
  download.file(url, file)
  install.packages(file, repos = NULL)
}

# SciViews::R
#remotes::install_github("SciViews/mlearning@v1.2.0")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/mlearning_1.2.0.tar.gz")
#remotes::install_github("phgrosjean/pastecs@v1.4.1")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/pastecs_1.4.1.tar.gz")
#remotes::install_github("phgrosjean/aurelhy@v1.0.8")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/aurelhy_1.0.8.tar.gz")
#remotes::install_github("SciViews/svMisc@v1.3.1")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/svMisc_1.3.1.tar.gz")
#remotes::install_github("SciViews/svBase@v1.2.1")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/svBase_1.2.1.tar.gz")
#remotes::install_github("SciViews/svFlow@v1.2.1")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/svFlow_1.2.1.tar.gz")
#remotes::install_github("SciViews/data.io@v1.4.1")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/data.io_1.4.1.tar.gz")
#remotes::install_github("SciViews/chart@v1.4.0")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/chart_1.4.0.tar.gz")
#remotes::install_github("SciViews/SciViews@v1.5.0")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/SciViews_1.5.0.tar.gz")
#remotes::install_github("SciViews/exploreit@v1.0.0")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/exploreit_1.0.0.tar.gz")
#remotes::install_github("SciViews/modelit@v1.0.0")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/modelit_1.0.0.tar.gz")

#remotes::install_github("rstudio/shinytest2@v1", upgrade = "never")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/shinytest2_0.1.0.9000.tar.gz")
#remotes::install_github("rstudio/learnr@v0.10.5.9000", upgrade = "never")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/learnr_0.10.5.9000.tar.gz")
#remotes::install_github("rstudio/gradethis@v0.2.8.9000", upgrade = "never")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/gradethis_0.2.8.9000.tar.gz")

#remotes::install_github("SciViews/learnitdown@v1.5.2")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/learnitdown_1.5.2.tar.gz")

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

# BioDataScience|1|2|3
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/BioDataScience_2022.1.0.tar.gz")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/BioDataScience1_2022.1.0.tar.gz")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/BioDataScience2_2022.1.0.tar.gz")
install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2022/files/BioDataScience3_2022.1.0.tar.gz")

# More items:
#install.packages(c(""), Ncpus = Ncpus)

# Restore options
options(repos = orepos)
options(install.packages.check.source = NULL)
