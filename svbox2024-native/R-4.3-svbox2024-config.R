# Need to do brew install gdal first and make sure to compile sf from sources
# install.packages("sf)", type = "source")

# Also need to create Rprofile.site which tools changes repos["CRAN"]!
# Copy-paste the content of R-4.3-svbox2024-config.sh in a terminal for that
# after closing R and RStudio. Restart RStudio and check that getOption("repos")
# returns the right value.
orepos <- getOption("repos")
repos = c(SciViews = "https://sciviews.r-universe.dev", CRAN = "@CRAN")
# The following one no longer exists
#repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2024-04-20"
# For macOS or Windows:
repos["CRAN"] <- "https://packagemanager.posit.co/cran/2024-04-20"
# For Ubuntu 22.04LTS Jammy Jellyfish, use this instead!
#repos["CRAN"] <- "https://packagemanager.posit.co/cran/__linux__/jammy/2024-04-20"
options(repos = repos)
options(timeout = 800) # Needed for sf and terra, increase if needed
Ncpus <- parallel::detectCores(logical = FALSE)
# If you don't want parallel install
#Ncpus <- 1L
# If there is a source package more recent than the binary, compile it:
options(install.packages.check.source = "yes")

update.packages() # Update MASS, Matrix & survival (but cannot compile Matrix from source)

# Now, we install roughly 300 packages + their dependencies...
# it makes a total of 551 package and 2.39GB on a Mac Intel.

install.packages("webshot")
webshot::install_phantomjs()

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
install.packages("sf", configure.args = "--with-proj-lib=$(brew --prefix)/lib/")
install.packages("terra")
install.packages("rpart.plot")
# Prefer installing this with parallel computation, but done at the end:
install.packages("data.table")
install.packages("ade4") # Requires RcppArmadillo + gfortran correctly installed
install.packages("nloptr") # Requires brew install cmake
install.packages("gert") # Requires brew install libgit2
install.packages("textshaping") # Requires brew install harfbuzz fribidi
install.packages("ggiraph") # Requires brew install libpng, needs a Makevars file!
install.packages("svglite") # Requires brew install libpng
install.packages(c("anytime", "ape", "assert", "assertthat", "automap",
  "available", "backports", "base64enc", "base64url", "bench", "bit", "bit64",
  "blastula", "blob", "bookdown", "boot", "broom", "broom.mixed", "butcher",
  "ca", "car", "chromote", "circular", "cli", "clisymbols", "coin", "collapse",
  "config", "conflicted", "convertr", "coro", "corrplot", "corrr", "covr",
  "cowplot", "crayon", "curl", "cyphr", "datasauRus", "DBI",
  "dbplyr", "devtools", "DiagrammeR", "dials", "digest", "discrim",
  "distributional", "distributions3", "doFuture", "doParallel", "doRNG", "dm",
  "DT", "dtplyr", "duckdb", "e1071", "egg", "ellipse", "emmeans", "esquisse",
  "evaluate", "factoextra", "FactoMineR", "fansi", "faraway", "fastcluster",
  "fastmap", "feasts", "flashClust", "flexdashboard", "flipdownr",
  "fontawesome", "forcats", "foreach", "formatR", "fortunes", "fs", "furrr",
  "future", "future.apply", "future.callr", "gdtools", "generics", "getPass",
  "GGally", "gganimate", #"ggconf" not available because archived?!,
  "ggcorrplot", "ggdendro", "ggExtra", "ggfortify", "ggpackets", "ggpubr",
  "ggrepel", "ggridges", "ggsci", "ggsignif",
  # Replace ggsn not available any more by ggspatial later on
  "ggsom", "ghclass", "gitcreds", "glmnet", "glue", "golem",
  "googlesheets4", "gridBase", "gridExtra", "gridGraphics", "gstat", "haven",
  "here", "Hmisc", "htmltools", "htmlwidgets", "httpuv", "httr", "igraph",
  "inline", "ipred", #"IRkernel" # No, not for macOS
  "iterators", "janitor", "job", "jsonlite",
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
  "slider", "sloop", "smotefamily", "sodium", "sortable", "sparklyr", # Not on SaturnCloud
  "spData",
  "spelling", "stars", "stringi", "stringr", "styler", "summarytools",
  "suppdata", "SuppDists", "svUnit", "sys", "targets", "testthat",
  "thematic", "tictoc", "tidymodels", "tidyr", "tidyverse", "tinytest", "tmap",
  "tmaptools", "todor", "transformr", "TSA", "tsibble", "tune", "usethis",
  "UsingR", "vctrs", "vegan", "vembedr", "vetiver", "vip", "viridis",
  "viridisLite", "visdat", "vroom", "waldo", "warp", "withr", "workflows",
  "workflowsets", "writexl", "WriteXLS", "xaringan", "xfun", "xtable", "xts",
  "yaml", "yardstick", "zeallot", "zoo"), Ncpus = Ncpus)

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
install.packages(c("S7", "usethis", "rlang", "groundhog", "equatags",
  "equatiomatic", "flextable", "mlearning", "pastecs", "aurelhy", "svMisc",
  "svBase", "svFlow", "data.io", "chart", "SciViews", "exploreit", "modelit",
  "inferit", "tabularise"), Ncpus = Ncpus)

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
install.packages(c("aws.s3", "aws.signature", "babynames", "bdsmatrix",
  "colourpicker", "cols4all", "colorblindcheck", "compareGroups", "coop",
  "docopt", "downloader", "dtts", "equatags", "fasttime", "finalfit",
  "flashlight", "forge", "fst", "ggdark", "ggforce", "ggmap", "ggpath",
  "ggtext", "ggThemeAssist", "ghapps", "groundhog", "kit", "languageserver",
  "littler", "octopus", "optimx", "parallelDist", "parsermd", "qs", "quartets",
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
Sys.setenv(NOT_CRAN = "true")
install.packages("polars", repos = "https://rpolars.r-universe.dev")
install.packages("polarssql", repos = c("https://rpolars.r-universe.dev", getOption("repos")))
install.packages("tidypolars", repos = c("https://etiennebacher.r-universe.dev", getOption("repos")))

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

# Note: maptools, rgdal, rgeos retired in 2023. sp now disconnected from rgdal and rgeos. Some maptools functions are moved to sp too. sp classes are S4, while sf classes are S3. See: https://r-spatial.org/book/sp-raster.html

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
  "dqrng",  "downlit", "duckdbfs", "duckplyr", "fixest", "ggeffects", "ggpmisc",
  "ggpp", "ggraph", "ggspatial", "GLMsData", "httr2", "lterdatasampler",
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
nrow(cip) # 283 (282 on Windows)
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
print(cip_error) # No errors!

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

remotes::install_github(c(
  'BioDataScience-Course/BioDataScience@v2024.0.0',
  'BioDataScience-Course/BioDataScience1@v2024.0.0',
  'BioDataScience-Course/BioDataScience2@v2024.0.0',
  'BioDataScience-Course/BioDataScience3@v2024.0.0'
), upgrade = 'always')

# TODO: install data.table and collapse with parallel computation
#
