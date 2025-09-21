# Need to do brew install gdal first and make sure to compile sf from sources
# install.packages("sf)", type = "source")

# Make sure the user library is empty in ~/Library/R/arm64/4.4/library
# or delete it and restart R/RStudio

# Also need to create Rprofile.site which tools changes repos["CRAN"]!
# Copy-paste the content of R-4.4-svbox2025-config.sh in a terminal for that
# after closing R and RStudio. Restart RStudio and check that getOption("repos")
# returns the right value.
orepos <- getOption("repos")
repos = c(SciViews = "https://sciviews.r-universe.dev", CRAN = "@CRAN")
# For macOS or Windows:
repos["CRAN"] <- "https://packagemanager.posit.co/cran/2025-04-10"
# For Ubuntu 22.04LTS Jammy Jellyfish, use this instead!
#repos["CRAN"] <- "https://packagemanager.posit.co/cran/__linux__/jammy/2025-04-10"
options(repos = repos)
options(timeout = 800) # Needed for sf and terra, increase if needed
Ncpus <- parallel::detectCores(logical = FALSE)
# If you don't want parallel install
#Ncpus <- 1L
# If there is a source package more recent than the binary, compile it:
options(install.packages.check.source = "yes")

update.packages() # Update cluster (2.1.8 -> 2.1.8.1),
# foreign (0.8-88 -> 0.8-90), lattice (0.22-6 -> 0.22-7),
# MASS (7.3-64 -> 7.3-65), Matrix (1.7.2 -> 1.7.3),
# mgcv (1.9-1 -> 1.9-3), nlme (3.1-167 -> 3.1-168).

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
install.packages("gdtools") # Could not compile correctly on arm64 (but OK on Mac x86_64) despite reinstalling brew deps
install.packages("~/pCloud\ Drive/Public\ Folder/svbox2025/files/gdtools_0.4.2_R4.4arm64.tgz", repos = NULL)
# or download it and...
#install.packages("~/Downloads/gdtools_0.4.2_R4.4arm64.tgz", repos = NULL)
library(gdtools)
# !!! Installed from binary on CRAN + config -> Confidentialité et sécurité -> Autoriser quand même
#install.packages("writexl") # If installed from binary, does not load ->
install.packages("writexl", type = "source") # But warnings -> to check!
# XML does not find the correct libxml2 on my Mac (mismatch between homebrew and miniconda!)
# brew install libxml2, then:
Sys.setenv(XML_CONFIG = "/opt/homebrew/Cellar/libxml2/2.13.8/bin/xml2-config")
# Then:
install.packages("XML", type = "source") # Need libxml2-dev installed
# Then, one can install tmap and tmaptools
install.packages(c("tmap", "tmaptools"))
# suppdata is now archived and taken out of svbox2025
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
  "future", "future.apply", "future.callr", "generics", "getPass",
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
  "SuppDists", "svUnit", "sys", "targets", "testthat", "thematic", "tictoc",
  "tidymodels", "tidyr", "tidyverse", "tinytest", "todor", "transformr", "TSA",
  "tsibble", "tune", "usethis", "UsingR", "vctrs", "vegan", "vembedr",
  "vetiver", "vip", "viridis", "viridisLite", "visdat", "vroom", "waldo",
  "warp", "withr", "workflows", "workflowsets", "WriteXLS", "xaringan", "xfun",
  "xtable", "xts", "yaml", "yardstick", "zeallot", "zoo"), Ncpus = Ncpus)

# From Bioconductor (SharedObject is new in svbox2025)
install.packages("BiocManager")
BiocManager::install(c("graph", "ComplexHeatmap", "Rgraphviz", "SharedObject" #, "RDRToolbox"
  ), update = FALSE, ask = FALSE)

# Dependencies for packages installed with install_from_url()
install.packages("magick") # 37.2MB
install.packages(c("getPass", "ggplotify", "proto", "renv", "shinylogs",
  "shinytoastr", "tsibble"), Ncpus = Ncpus)

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
# Now replaced by R-universe
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
# equatags is too old -> install correct version from GitHub
remotes::install_github("ardata-fr/equatags@462e77b")
# New in svbox2025: svTidy, svFast, data.trame and helpai
install.packages(c("S7", "usethis", "rlang", "groundhog", #"equatags",
  "equatiomatic", "flextable", "mlearning", "pastecs", "aurelhy", "svMisc",
  "svBase", "svFlow", "data.trame", "data.io", "chart", "SciViews", "exploreit",
  "modelit", "inferit", "tabularise", "svTidy", "svFast", "helpai"),
  Ncpus = Ncpus)

# More items for 2023 (note: littler and unix not available for Windows):
install.packages("littler") # Need brew install libdeflate on Mac Intel
install.packages(c("aws.s3", "aws.signature", "babynames", "bdsmatrix",
  "colourpicker", "cols4all", "colorblindcheck", "compareGroups", "coop",
  "docopt", "downloader", "dtts", "equatags", "fasttime", "finalfit",
  "flashlight", "forge", "fst", "ggdark", "ggforce", "ggmap", "ggpath",
  "ggtext", "ggThemeAssist", "ghapps", "groundhog", "kit", "languageserver",
  "octopus", "optimx", "parallelDist", "parsermd", "qs", "quartets",
  "r2d3", "RCurl", "RgoogleMaps", "roll", "rrapply", "santoku",
  "shinyDatetimePickers", "shinyFeedback", "shinytest2", "shinythemes", "spdl",
  "tiff", "tsbox", "unix"),
  Ncpus = Ncpus)

# On Mac Intel, I got errors to compile littler
# I had to install gfortran-14.2-universal.pkg from CRAN -> MacOS -> tools
# On Windows, I also got en error to install parallelDist. I had to install rtools44

# More packages
tinytex::install_tinytex() # Cancel if a LaTeX distribution already exists
# Check Quarto/R Markdown html, pdf & docx, check presentations Beamer, ioslide, slidy & Powerpoint -> OK

# Not in SaturnCloud !
Sys.setenv(NOT_CRAN = "true")
install.packages("polars", repos = "https://rpolars.r-universe.dev")
install.packages("polarssql", repos = c("https://rpolars.r-universe.dev", getOption("repos")))
install.packages("tidypolars", repos = c("https://etiennebacher.r-universe.dev", getOption("repos")))

# More items for 2024:
install.packages("git2r") # Need libgit2 >= 1.0, openssl & libssh2 -> brew install libgit2
install.packages("xgboost")
install.packages(c("atime", "connectapi", "correctR", "correlationfunnel", "cv",
  "dqrng",  "downlit", "duckdbfs", "duckplyr", "fixest", "ggeffects", "ggpmisc",
  "ggpp", "ggraph", "ggspatial", "GLMsData", "httr2", "lterdatasampler",
  "modeldata", "modeldatatoo", "poorman", "reactable", "reactable.extras",
  "searcher", #"see" No, because too many dependencies!
  "servr", "table1", "this.path", "tidyfast", "tinytable"),
  Ncpus = Ncpus)

# New in svbox2025:
install.packages(c("nanoparquet", "mirai", "nanonext", "explore",
  "constructive", "qs2", "latex2exp", "syrup", "ellmer", "log4r", "tidytable",
  "arrow", "forecast", "ggfun", "ggimage", "gt", "gtsummary", "hexSticker",
  "partools", "shapefiles", "vcd"),
  Ncpus = Ncpus)

# Missing items in 2025:
install.packages(c("broom.helpers", "crul", "cyclocomp", "diffr", "fresh",
  "gfonts", "httpcode", "lmtest", "R.rsp", "rcrossref", "shinycssloaders",
  "shinydashboardPlus", "shinyTime", "swagger", "timevis", "triebeard",
  "urltools", "waiter", "webutils", "widgetframe"), Ncpus = Ncpus)

# Compare with svbox2024:
ip2025 <- installed.packages()
ip2025names <- rownames(ip2025)
# On Saturn Cloud svbox2024, do this:
#ip2024 <- installed.packages()
#cat(rownames(ip2024), sep = '", "') # Copy-paste the output here under and adapt:
ip2024names <- c(
  # User library
  "BioDataScience", "BioDataScience1", "BioDataScience2", "BioDataScience3",

  # SciViews complements
  "abind", "ade4", "anytime", "ape", "AsioHeaders", "assert", "assertthat",
  "atime", "attempt", "aurelhy", "automap", "available", "babynames",
  "base64url", "bdsmatrix", "bench", "BH", "bibtex", "BiocGenerics",
  "BiocManager", "BiocVersion", "bitops", "blastula", "bookdown", "boot",
  "broom.helpers", "broom.mixed", "bslib", "bundle", "butcher", "ca", "car",
  "carData", "caTools", "cereal", "chart", "checkmate", "chromote", "chron",
  "circlize", "circular", "class", "classInt", "clisymbols", "clock", "clue",
  "cluster", "coda", "codetools", "coin", "collapse", "collections",
  "colorblindcheck", "colourpicker", "cols4all", "commonmark", "compareGroups",
  "ComplexHeatmap", "config", "confintr", "connectapi", "convertr", "coop",
  "coro", "correctR", "correlationfunnel", "corrplot", "corrr", "covr",
  "cowplot", "crosstalk", "crul", "cv", "cyclocomp", "cyphr", "data.io",
  "datamods", "datasauRus", "dbscan", "debugme", "deldir", "dendextend",
  "diagram", "DiagrammeR", "dials", "DiceDesign", "dichromat", "diffr",
  "digest", "discrim", "distributional", "distributions3", "dm", "doFuture",
  "doParallel", "doRNG", "downloader", "dqrng", "dreamerr", "DT", "dtts",
  "duckdb", "duckdbfs", "duckplyr", "e1071", "egg", "ellipse", "emmeans",
  "entropy", "equatags", "equatiomatic", "esquisse", "estimability",
  "exploreit", "fabletools", "factoextra", "FactoMineR", "faraway",
  "fastcluster", "fasttime", "feasts", "filelock", "finalfit", "fixest",
  "flashClust", "flashlight", "flexdashboard", "flextable", "flipdownr", "FNN",
  "fontBitstreamVera", "fontLiberation", "fontquiver", "foreach", "foreign",
  "forge", "formatR", "Formula", "fortunes", "fresh", "fst", "fstcore", "furrr",
  "future", "future.apply", "future.callr", "gclus", "gdtools", "geojsonsf",
  "geometries", "GetoptLong", "getPass", "gfonts", "GGally", "gganimate",
  "ggcheck", "ggcorrplot", "ggdark", "ggdendro", "ggdist", "ggeffects",
  "ggExtra", "ggforce", "ggformula", "ggfortify", "ggiraph", "ggmap",
  "ggpackets", "ggpath", "ggplotify", "ggpmisc", "ggpp", "ggpubr", "ggraph",
  "ggrepel", "ggridges", "ggsci", "ggsignif", "ggsom", "ggspatial", "ggstats",
  "ggtext", "ggThemeAssist", "ghapps", "ghclass", "git2r", "glmnet", "GLMsData",
  "GlobalOptions", "globals", "golem", "gower", "GPfit", "gplots", "gradethis",
  "graph", "graphlayouts", "gridBase", "gridExtra", "gridGraphics", "gridtext",
  "groundhog", "gstat", "gtools", "hardhat", "HardyWeinberg", "HistData",
  "Hmisc", "htmlTable", "htmltools", "httpcode", "hunspell", "igraph", "infer",
  "inferit", "inline", "insight", "interp", "intervals", "ipred", "IRanges",
  "iterators", "janeaustenr", "janitor", "job", "jomo", "jose", "jpeg",
  "jsonify", "kableExtra", "katex", "kernlab", "KernSmooth", "keyring", "kit",
  "kknn", "knitcitations", "knitr", "kohonen", "labelled", "languageserver",
  "lattice", "latticeExtra", "lava", "lazyeval", "leafem", "leaflet",
  "leaflet.extras", "leaflet.providers", "leafpm", "leafpop", "leafsync",
  "leaps", "learnitdashboard", "learnitdown", "learnitgrid", "learnitprogress",
  "learnr", "lhs", "libcoin", "LiblineaR", "lindia", "lintr", "listenv",
  "littler", "lme4", "lmerTest", "lmodel2", "lmtest", "lobstr", "locfit",
  "lpSolve", "lterdatasampler", "lubridate", "lwgeom", "magick", "mapedit",
  "maplegend", "maps", "mapsf", "mapview", "MASS", "Matrix", "MatrixModels",
  "matrixStats", "MetricsWeighted", "mgcv", "mice", "microbenchmark", "mime",
  "miniCRAN", "minqa", "mitml", "mlbench", "mlearning", "modeldata",
  "modeldatatoo", "modelenv", "modelit", "modeltools", "mongolite", "mosaic",
  "mosaicCore", "mosaicData", "multcomp", "multcompView", "mvtnorm", "naniar",
  "nanotime", "nlme", "nloptr", "nnet", "norm", "nparcomp", "numDeriv",
  "nycflights13", "octopus", "officer", "optimx", "ordinal", "packrat",
  "pagedown", "pak", "palmerpenguins", "pan", "pander", "parallelDist",
  "parallelly", "parsedate", "parsermd", "parsnip", "pastecs", "patchwork",
  "pbkrtest", "permute", "phosphoricons", "piggyback", "pingr", "pins",
  "pixmap", "pkgcache", "pkgdepends", "PKI", "plogr", "plotly", "plyr",
  "polyclip", "polynom", "poorman", "pracma", "prettyglm", "printr", "pROC",
  "prodlim", "profmem", "progressr", "proto", "proxy", "pryr", "pwr", "qap",
  "qs", "quadprog", "quantmod", "quantreg", "quartets", "quarto", "questionr",
  "R.cache", "R.methodsS3", "R.oo", "R.rsp", "R.utils", "r2d3", "randomForest",
  "ranger", "rapidjsonr", "rapidoc", "RApiSerialize", "rapportools", "raster",
  "RcppArmadillo", "RcppCCTZ", "RcppDate", "RcppEigen", "RcppParallel",
  "RcppSpdlog", "rcrossref", "RCurl", "reactable", "reactable.extras",
  "reactlog", "reactR", "recipes", "RefManageR", "registry", "renv", "repr",
  "reprex", "reshape", "reshape2", "rex", "rgl", "RgoogleMaps", "Rgraphviz",
  "RhpcBLASctl", "rhub", "rio", "rjson", "rmarkdown", "rmdformats", "rngtools",
  "ROCR", "roll", "rosm", "rpart", "rpart.plot", "rrapply", "rsample",
  "rsconnect", "Rsolnp", "RSQLite", "rstatix", "rticles", "s2", "S4Vectors",
  "S7", "sandwich", "santoku", "sass", "satellite", "scatterplot3d", "SciViews",
  "searcher", "secretbase", "seriation", "servr", "sf", "sfheaders", "sftime",
  "shape", "shinyAce", "shinybusy", "shinycssloaders", "shinydashboard",
  "shinydashboardPlus", "shinyDatetimePickers", "shinyFeedback", "shinyjs",
  "shinylogs", "shinytest", "shinytest2", "shinythemes", "shinyTime",
  "shinytoastr", "shinyWidgets", "showimage", "sitmo", "skimr", "slider",
  "sloop", "smotefamily", "snakecase", "SnowballC", "sodium", "sortable", "sp",
  "spacesXYZ", "spacetime", "SparseM", "spatial", "spData", "spdl", "spelling",
  "splus2R", "SQUAREM", "stars", "stringdist", "stringfish", "stringmagic",
  "styler", "summarytools", "suppdata", "SuppDists", "survival", "svBase",
  "svFlow", "svglite", "svMisc", "svUnit", "swagger", "table1", "tabularise",
  "targets", "terra", "TH.data", "thematic", "this.path", "tictoc", "tidycat",
  "tidyfast", "tidygraph", "tidymodels", "tidytext", "tiff", "timeDate",
  "timevis", "tinytable", "tinytest", "tinytex", "tmap", "tmaptools", "toastui",
  "todor", "tokenizers", "transformr", "triebeard", "truncnorm", "TSA", "tsbox",
  "tseries", "tsibble", "TSP", "TTR", "tune", "tweenr", "ucminf", "units",
  "unix", "UpSetR", "urltools", "UsingR", "V8", "vegan", "vembedr", "vetiver",
  "vip", "viridis", "visdat", "visNetwork", "waiter", "warp", "webdriver",
  "webshot", "websocket", "webutils", "whoami", "widgetframe", "wk",
  "workflows", "workflowsets", "writexl", "WriteXLS", "xaringan", "xfun",
  "xgboost", "XML", "xmlparsedata", "xslt", "xts", "yardstick", "yesno",
  "yulab.utils", "zeallot", "zoo",

  # Saturn Cloud
  "askpass", "aws.s3", "aws.signature", "backports", "base64enc", "bit",
  "bit64", "blob", "brew", "brio", "broom", "bslib", "cachem", "callr",
  "cellranger", "cli", "clipr", "colorspace", "commonmark", "conflicted",
  "cpp11", "crayon", "credentials", "curl", "data.table", "DBI", "dbplyr",
  "desc", "devtools", "diffobj", "digest", "docopt", "downlit", "dplyr",
  "dtplyr", "ellipsis", "evaluate", "fansi", "farver", "fastmap", "fontawesome",
  "forcats", "fs", "gargle", "generics", "gert", "ggplot2", "gh", "gitcreds",
  "glue", "googledrive", "googlesheets4", "gtable", "haven", "here", "highr",
  "hms", "htmltools", "htmlwidgets", "httpuv", "httr", "httr2", "ids", "ini",
  "isoband", "jquerylib", "jsonlite", "knitr", "labeling", "later", "lifecycle",
  "littler", "lubridate", "magrittr", "markdown", "memoise", "mime", "miniUI",
  "modelr", "munsell", "odbc", "openssl", "pillar", "pkgbuild", "pkgconfig",
  "pkgdown", "pkgload", "png", "praise", "prettyunits", "processx", "profvis",
  "progress", "promises", "ps", "purrr", "R6", "ragg", "rappdirs", "rcmdcheck",
  "RColorBrewer", "Rcpp", "RcppTOML", "readr", "readxl", "rematch", "rematch2",
  "remotes", "reprex", "reticulate", "rlang", "rmarkdown", "roxygen2",
  "rprojroot", "rstudioapi", "rversions", "rvest", "sass", "scales", "selectr",
  "sessioninfo", "shiny", "sourcetools", "stringi", "stringr", "sys",
  "systemfonts", "testthat", "textshaping", "tibble", "tidyr", "tidyselect",
  "tidyverse", "timechange", "tinytex", "tzdb", "urlchecker", "usethis", "utf8",
  "uuid", "vctrs", "viridisLite", "vroom", "waldo", "whisker", "withr", "xfun",
  "xml2", "xopen", "xtable", "yaml", "zip",

  # Base and recommended
  "base", "boot", "class", "cluster", "codetools", "compiler", "datasets",
  "foreign", "graphics", "grDevices", "grid", "KernSmooth", "lattice", "MASS",
  "Matrix", "methods", "mgcv", "nlme", "nnet", "parallel", "rpart", "spatial",
  "splines", "stats", "stats4", "survival", "tcltk", "tools", "utils")

# Note: maptools, rgdal, rgeos retired in 2023. sp now disconnected from rgdal and rgeos. Some maptools functions are moved to sp too. sp classes are S4, while sf classes are S3. See: https://r-spatial.org/book/sp-raster.html

# Missing items from 2024:
ip2024names[!ip2024names %in% ip2025names]
# learnitr pkgs + gradethis + ggcheck + BioDataScience packages
# suppdata is not available anymore and eliminated from svbox2025

# New items:
ip2025names[!ip2025names %in% ip2024names]
# BWStest, cards, constructive, data.trame, datawizard, Deriv, doBy, ellmer,
# explore, glmmTMB, gmp, helpai, kSamples, latex2exp, leafgl, leaflegend,
# litedown, log4r, logger, mirai, nanonext, nanoparquet, PMCMRplus, polars,
# polarssql, qs2, rbibutils, Rdpack, reformulas, Rmpfr, sfd, SharedObject,
# sparklyr, sparsevctrs, svFast, svTidy, syrup, tidypolars, tidytable, TMB
#
# + arrow forecast ggfun ggimage gt gtsummary hexSticker partools shapefiles vcd
# + MatrixExtra float rsparse mlapi lgr showtextdb rje text2vec polyreg fracdiff
# urca bigD juicyjuice hexbin showtext sysfonts regtools pdist
# on Windows, I got translations too

# From the learnitr universe:
install.packages(c('learnr', 'shinytest2'))
remotes::install_github(c('rstudio/gradethis@v0.2.14'), upgrade = 'never') # No commit since 2 years!

install.packages(c("ggcheck", "learnitdown", "learnitgrid",
  "learnitprogress", "learnitdashboard"), repos =
    c(learnitr = "https://learnitr.r-universe.dev", CRAN = repos["CRAN"]))

# OpenMP support:
# Need to do this (see ):
#curl -O https://mac.r-project.org/openmp/openmp-17.0.6-darwin20-Release.tar.gz
#sudo tar fvxz openmp-17.0.6-darwin20-Release.tar.gz -C /
install.packages("data.table", type = "source")
library(data.table)
Sys.setLanguage("en") # Otherwise, tests fail in another language!
data.table::test.data.table()
data.table::getDTthreads() > 1 # Check that parallel computation works
install.packages("collapse", type = "source")
collapse::get_collapse("nthreads")
install.packages("kit", type = "source")
library(kit)
install.packages("fstcore", type = "source")
library(fstcore)
# Make sure we have version 0.2.2 of equatags
remotes::install_github("ardata-fr/equatags@462e77b")

# Restore options
options(repos = orepos)
options(install.packages.check.source = NULL)

# Now, check if the packages that need compilation at least load correctly
ip <- as.data.frame(installed.packages())
cip <- ip[ip$NeedsCompilation == "yes", ]
cip <- cip[!is.na(cip$Package), ]
nrow(cip) # 297 (282 on Windows)
cip_error <- character(0)
# Need to load gert first, otherwise, R crashes?!
library(gert)
for (cipak in na.omit(cip$Package)) {
  message("Checking package ", cipak, " ...")
  res <- try(library(cipak, character.only = TRUE), silent = FALSE)
  if (inherits(res, "try-error")) {
    cip_error <- c(cip_error, cipak)
  } else {
    try(detach(paste0("package:", cipak), character.only = TRUE, unload = TRUE),
      silent = TRUE)
  }
}
print(cip_error) # I got satellite and raster, but when restarting R, it works

# Mac: There are 759 packages in sciviews-library, 1.95Gb on disk on arm64, 1.95Gb on x86_64
# Windows: There are 690 packages in C:/Users/<username>/AppData/Local/R/win-library/4.4, 1.70Gb on disk

# Once it is done, rename library into sciviews-library and do:
#No, read further! -> XZ_OPT=-e9T0 tar cJvf sciviews-library2025_<os>_<ver>.tar.xz sciviews-library
# but uses only one core -> tar first, then xz.
#
# For Mac silicon:
#cd ~/Library/R/arm64/4.4
#tar cvf sciviews-library2025_mac_arm64.tar sciviews-library
#xz -z -9 -e -T0 -v sciviews-library2025_mac_arm64.tar
# Once compressed, it makes 739Mb for _mac_arm64
#
# For Mac Intel:
# cd ~/Library/R/x86_64/4.4 or
#tar cvf sciviews-library2025_mac_x86_64.tar sciviews-library
#xz -z -9 -e -T0 -v sciviews-library2025_mac_x86_64.tar
# Once compressed, it makes 785Mb for _mac_x86_64
#
# For Windows Intel
#cd C:/Users/phgro/AppData/Local/R/sciviews-library
#tar cvf sciviews-library2025_win_x86_64.tar 4.4
#xz -z -9 -e -T0 -v sciviews-library2025_win_x86_64.tar
# Once compressed, it makes 804Mb for _win_x86_64

################################################################################
# Optional stuff:

# For SDD courses
# BioDataScience|1|2|3
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/BioDataScience1_2025.0.0.tar.gz")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/BioDataScience2_2025.0.0.tar.gz")
##install_from_url("https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files/BioDataScience3_2025.0.0.tar.gz")

remotes::install_github(c(
  'BioDataScience-Course/BioDataScience@v2025.0.0',
  'BioDataScience-Course/BioDataScience1@v2025.0.0',
  'BioDataScience-Course/BioDataScience2@v2025.0.0',
  'BioDataScience-Course/BioDataScience3@v2025.0.0'
), upgrade = 'always')

################################################################################
# Building a patch file in R:
patch_date <- "2025-09-20"
if (.Platform$OS.type == "windows") {
  os <- "win_x86_64"
  patch_dir <- "~/svpatch/4.4"
} else if (grepl("darwin", R.version$os)) {# macOS
  if (R.version$arch == "aarch64") {
    os <- "mac_arm64"
  } else {
    os <- "mac_x86_64"
  }
  patch_dir <- "~/svpatch/sciviews-library"
}
dir.create(patch_dir, recursive = TRUE)
.libPaths(c(patch_dir, .libPaths()))
# Install what need to be patched
remotes::install_github("datalorax/equatiomatic@572a8e9", force = TRUE)
odir <- setwd(dirname(patch_dir))
patch_file <- paste0("sciviews-library2025_", os, "_", patch_date, ".tar.xz")
tar(patch_file, basename(patch_dir), compression = "xz", compression_level = 9)
# Calculate file size + md5 and place these values in the install script
file.size(patch_file)
tools::md5sum(patch_file)
# Reset the system
setwd(odir)
.libPaths(.libPaths()[-1])
