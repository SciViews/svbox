# Install R packages for the SciViews Box 2024
# TODO: tinytex::install_tinytex()

# On MacOS, compile data.table with OpenMP
# brew update && brew install libomp
# brew install pkg-config
# edit ~/.R/Makevars and addn for Intel:
#  CPPFLAGS += -Xclang -fopenmp and LDFLAGS += -lomp
# for silicon:
# LDFLAGS += -L/opt/homebrew/opt/libomp/lib -lomp
# CPPFLAGS += -I/opt/homebrew/opt/libomp/include -Xclang -fopenmp
# Then in R:
# install.packages("data.table", type = "source")
# or from command line:
# PKG_CPPFLAGS='-Xclang -fopenmp' PKG_LIBS=-lomp R CMD INSTALL data.table-1.14.8.tar.gz
# with version being 1.14.8
#
#
# This does not work, so, I follow instruction at:https://mac.r-project.org/openmp/
#
# Xcode version installed:
# pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | grep version # 14.2
# cd ~/Downloads
# curl -O https://mac.r-project.org/openmp/openmp-14.0.6-darwin20-Release.tar.gz
# sudo tar fvxz openmp-14.0.6-darwin20-Release.tar.gz -C /
#
# Then compile data.table from sources
# PKG_CPPFLAGS='-Xclang -fopenmp' PKG_LIBS=-lomp R CMD INSTALL data.table-1.14.8.tar.gz
# test it with test.data.table() in R, but outside RStudio

# Set up first the correct repo!
is_macos <- function()
  grepl("darwin", R.version$os)

is_linux <- function()
  .Platform$OS.type == "unix" && !grepl("darwin", R.version$os)

ubuntu_codename <- function() {
  codename <- try(system("lsb_release -sc", intern = TRUE), silent = TRUE)
  if (inherits(codename, "try-error"))
    codename <- ""
  if (!codename %in% c("bionic", "focal", "jammy"))
    codename <- ""
  codename
}

orepos <- getOption("repos")
if (is_linux()) {
  # We deal automatically with Ubuntu bionic, focal or jammy, ...
  # or you have to provide the URL yourself
  codename <- ubuntu_codename()
  if (codename == "") {
    # This is to install from source, but you are better to select the correct
    # URL for your particular Linux distro here
    options(repos = c(SciViews = "https://sciviews.r-universe.dev",
      CRAN = "https://packagemanager.posit.co/cran/2024-04-20"))
  } else {# Ubuntu bionic, focal or jammy
    options(repos = c(SciViews = "https://sciviews.r-universe.dev", CRAN = paste0(
      "https://packagemanager.rstudio.com/cran/__linux__/",
      codename, "/2024-04-20")))
  }
} else {# MacOS or Windows
  # MRAN is down now, swith to Posit public package manager
  # (but no Mac binaries there)
  #options(repos = c(CRAN = "https://mran.microsoft.com/snapshot/2024-04-20"))
  options(repos = c(SciViews = "https://sciviews.r-universe.dev",
    CRAN = "https://packagemanager.posit.co/cran/2024-04-20"))
}

lib_path <- if (is_linux()) {
  "/usr/local/lib/R/site-library"
} else {# MacOS or Windows
  .libPaths()[1L]
}

# TODO: rework this...
## We use groundhog (not yet)
install.packages("groundhog")
## Install with groundhog
#groudhog_day <- "2024-04-20"
#groudhog_install <- function(pkgs, date = groundhog_day)
#  groundhog::groundhog.library(pkgs, date = date)

#groundhog::get.groundhog.folder()
# change with groundhog::set.groundhog.folder(<path>)


# Install more packages...
missing_packages <- character(0)
available_packages <- available.packages()

deps <- function(pkgs, available = available_packages, lib = lib_path) {
  suppressMessages(utils:::getDependencies(pkgs, dependencies = TRUE,
    available = available, lib = lib, binary = !is_linux()))
}

is_installed <- function(pkgs) {
  is_installed_one <- function(pkg)
    as.logical(!is.na(suppressWarnings(packageDescription(pkg))[1]))
  l <- length(pkgs)
  if (l < 1) {
    res <- logical(0)
  } else {
    res <- rep(TRUE, length.out = l)
    for (i in 1:l)
      res[i] <- is_installed_one(pkgs[i])
  }
  res
}

install_packages_deps <- function(pkgs, lib = lib_path) {
  pkgs_with_deps <- deps(pkgs, lib = lib)
  pkgs_to_install <- pkgs_with_deps[!is_installed(pkgs_with_deps)]
  if (!length(pkgs_to_install))
    return()
  cat("=== Installing ", paste(pkgs_to_install, collapse = ", "),
    "...\n", sep = "")
  install.packages(pkgs_to_install, lib = lib,
    Ncpus = parallel::detectCores())
  pkgs_not_installed <- pkgs_to_install[!is_installed(pkgs_to_install)]
  if (length(pkgs_not_installed)) {
    cat(paste(pkgs_not_installed, collapse = ", "),
      " not installed!\n", sep = "")
    missing_packages <<- c(missing_packages, pkgs_not_installed)
  } else {
    cat("... done.\n")
  }
}

install_packages_bioconductor <- function(pkgs, lib = lib_path) {
  # Force installing only in site-library folder under Linux
  if (is_linux()) {
    olibPaths <- .libPaths()
    .libPaths(lib)
    on.exit(.libPaths(olibPaths))
  }
  pkgs <- pkgs[!is_installed(pkgs)]
  if (!length(pkgs))
    return()
  cat("=== Installing ", paste(pkgs, collapse = ", "), "...\n", sep = "")
  for (pkg in pkgs) {
    BiocManager::install(pkg, update = FALSE, ask = FALSE)
  }
  pkgs_not_installed <- pkgs[!is_installed(pkgs)]
  if (length(pkgs_not_installed)) {
    cat(paste(pkgs_not_installed, collapse = ", "),
      " not installed!\n", sep = "")
    missing_packages <<- c(missing_packages, pkgs_not_installed)
  } else {
    cat("... done.\n")
  }
}

# pkgs as name/pkg@version
install_packages_github <- function(pkgs, force = FALSE, lib = lib_path) {
  # Force installing only in site-library folder under Linux
  if (is_linux()) {
    olibPaths <- .libPaths()
    .libPaths(lib)
    on.exit(.libPaths(olibPaths))
  }
  pkg_names <- sub("^[^/]+/([^@]+)@?.*$", "\\1", pkgs)
  # Special case for instertable which repository spells insert_table!
  pkg_names[pkg_names == "insert_table"] <- "inserttable"
  if (!isTRUE(force)) {
    keep <- !is_installed(pkg_names)
    pkg_names <- pkg_names[keep]
    pkgs <- pkgs[keep]
  } else {
    # TODO: remove those packages first to make sure... or check version?!
  }
  if (!length(pkgs))
    return()
  cat("=== Installing ", paste(pkg_names, collapse = ", "), "...\n", sep = "")
  for (pkg in pkgs) {
    remotes::install_github(pkg, upgrade = "never")
  }
  pkgs_not_installed <- pkg_names[!is_installed(pkg_names)]
  if (length(pkgs_not_installed)) {
    cat(paste(pkgs_not_installed, collapse = ", "),
      " not installed!\n", sep = "")
    missing_packages <<- c(missing_packages, pkgs_not_installed)
  } else {
    cat("... done.\n")
  }
}

# Get an idea about how long it takes to install all these packages
install_start <- Sys.time()

install.packages("BiocManager")

# First install bioconductor packages that we need
# graph for several packages, Rgraphviz for loon and proftools, RDRToolbox for
# loon
install_packages_bioconductor(c("graph", "ComplexHeatmap", "Rgraphviz",
  "RDRToolbox"))

# Recommended packages
# Not on the Mac or Windows ? What about Linux, already installed ?
#install_packages_deps(c("boot", "class", "cluster", "codetools", "foreign",
#  "KernSmooth", "lattice", "MASS", "Matrix", "mgcv", "nlme", "nnet", "rpart",
#  "spatial", "survival"))

# Tidyverse and extensions
install_packages_deps(c("tidyverse",
  "dtplyr", "dbplyr", # dplyr extensions
  "infer", # Hypothesis test
  "tibbletime", "tsibble", # Tidy objects (tibbletime not any more)
#  "tidygraph", "tidytext",  # Tidy extensions (no!)
  "naniar", "skimr", # Summary stats
#  "purrrlyr", "seplyr", "sweep", "widyr",  # Tidy tools (no, sweep and widyr are nice!)
  "tidylog")) # Debug tidy operations

# Knitr extensions
install_packages_deps(c("formattable", "printr", # Objects formatting
  "kableExtra",  "pander", "stargazer", "texreg", "ztable", # Tables
  #"patchDVI", "patchSynctex", "tikzDevice", # LaTeX extensions (no)
  #"knitrProgressBar", "knitrBootstrap",
  "knitcitations")) # Knitr extensions (only knitcitation in comment)

# R markdown tools and formats
install_packages_deps(c("blogdown",
  #"bookdownplus", # Not on CRAN any more?
  "flexdashboard", "pagedown",
  "rmdformats", "xaringan", # No vitae, scholar (no bookdownplus)
  "linl", "pinp", "tint", # R markdown documents
  #"bsplus", "captioner", "kfigr", # R Markdown additions (no bsplus & kfigr) + captioner not on CRAN any more?
  "ari", # Create video presentations from R Markdown files (no)
  "vembedr")) # R Markdown addition

# RStudio addins and tools
install_packages_deps(c("convertr", "questionr"))
  #"citr", "colourpicker", "condformat", # (only convertr)
  #"listviewer", , # Addins (no listviewer)
  #"manipulate")) # Plot manipulation (no)

# Shiny extensions
install_packages_deps(c(
  #"jsTree", "rclipboard", "reactR", "rglwidget", # (no)
  #"shinyalert", "shinybootstrap2", "shinyDND", # (no)
  "rhandsontable", "shinyFeedback", 
  #"shinyFiles", "shinyjqui",
  "shinyjs", "shinylogs",
  #"shinymanager", "shinymaterial", "shinyShortcut", "ShinyTester", "shinyTime",
  "shinytoastr", # (only shinyjs, shinylogs & shinytoastr)
  #"shinyTree", "widgetframe", # Shiny extensions (no)
  "shinydashboard", #"argonDash", # Dashboards (only shinydashboard in comment)
  "reactlog")) # Debug shiny

# Object oriented
install_packages_deps(c("proto", "R6")) # Alternate objects (ok)
  #"errors", "units", # Units and error propagation objects (no)
  #"sets", # sets objects (no)
  #"labelVector", "narray", "rlist")) # Generic objects extensions (no)

# Date & time
install_packages_deps(c("anytime",
  #"date", "fasttime",
  "nanotime")) # Only anytime & nanotime

# Character strings & files
install_packages_deps(c(
  #"enc", "gsubfn", "strex", # String functions (no)
  "fs", "here", "filehash"))
  #"filehashSQLite", "archivist.github")) # Files (fs & here ok, the rest in comment)

# Datasets (dataset-only packages, or packages to access datasets)
install_packages_deps(c("babynames", "datasauRus", "gapminder",
  "hflights",
  #"repurrrsive",
  "titanic", "nycflights13")) # datasauRus & nycflights13 Ok, babynames & titanic in comment, the rest no

# Import/export
# Note: magick also suggests tesseract & gifski but we are not going to install
# these right now (they both need too large depedencies)
# For gifski, you need rust/cargo with sudo apt install -y cargo (+ 283Mb!)
install_packages_deps(c(
  #"import", "rio",
  "fst", # Alternate import mechanisms (all in comment)
  "writexl", "WriteXLS",
  #"XLConnect", "dataframes2xls", # Excel files (writexl and WriteXLS ok, the rest no)
  #"googledrive", "readODS", # Office formats (googledrive in comments, readODS no)
  #"rmatio", # Scientific data (no)
  #"RProtoBuf", "RcppTOML", # Various formats (no)
  "jpeg", "bmp", "tiff", "webp",  # Image formats (in comment, webp no)
  "magick", # Image manipulation (ok)
  "transformr")) # Image animation (ok, required by gganimate)

# Databases
install_packages_deps(c("mongolite", "odbc"))
  #"pool", "RMariaDB",
  "RPostgres", # mongolite & odbc OK, the rest no
  #"rquery", "sqldf")) # no

# Plots
# Warning: dependencies 'cplots', 'd3heatmap', 'graphicsQC' are not available
install_packages_deps(c("Cairo", "svglite",  # Devices
  #"gridSVG", "grImport", "grImport2", # Graphical items import/export (no)
  "gridBase",
  #"prepplot", "rasterVis", # General base/grid tools (gridBase OK, the others no)
  #"tactile", # Lattice extension (commented out)
  #"graphicsQC", # Debugging plots (no)
  #"fontcm", "showtext", # Fonts management (no)
  #"colorRamps", # Color management (no)
  #"magicaxis", # Axes management (no)
  #"multipanelfigure",  # Multipanel plots (no)
  #"googleVis", "ggvis", "rbokeh", # Other plot engines (no)
  #"animation", # Plot animations (no)
  #"rayshader", # Ray-shading (no)
  #"beanplot", "corrgram", "cplots", "d3heatmap",
  "DiagrammeR"))
  #"DiagrammeRsvg", # DiagrammeR ok, the rest no)
  #"networkD3", "sankey", "timevis", "vcdExtra", "wordcloud2")) # More plots (no)

# Plots (ggplot2 extensions)
# !!! ggROC + ggsn not available
install_packages_deps(c("ggcorrplot",
  #"ggdag", "ggdark", "ggedit",
  "ggExtra", # ggcorrplot & ggExtra OK, the rest no)
  #"ggfittext",
  "ggfortify",
  #"ggimage",
  "ggiraph", "ggiraphExtra",
  #"ggjoy", # ggfortify ok, ggimage, ggiraph comment, rest no
  "ggmap",
  "ggmosaic", "ggnetwork", "ggparallel", "ggplotAssist", "ggpmisc", # ggmoisaic comment, the rest no
  #"ggpolypath",
  "ggpubr", "ggRandomForests",
  #"ggraph",
  "ggrepel", "ggridges", # except ggRandomForests in comment and ggplotmath + ggraph no
  "ggROC", "ggsci", "ggseas", "ggsignif", "ggsn",
  #"ggspatial", "ggstance", # ggsci + ggsn ok, ggsignif comment, rest no
  #"ggtern", "ggThemeAssist", "ggthemes", "breakDown",
  "cowplot", "egg"))
  #"lemon",
  #"qqplotr", "treemapify", "visreg")) # cowplot + egg ok, rest no

# Reproducible research
install_packages_deps(c(
  "checkpoint", "drat", "packrat"))
  #"rbundler")) # Reproducibles packages loading
  #"liftr", # Containerize R Markdown documents (no)
  #"drake", "ProjectTemplate", # Project structure and workflow (no)
  #"sessioninfo", "statcheck")) # Misc (sessionifo ok, statcheck no)

# Teaching (see also Rcmdr)
install_packages_deps(c(
  #"swirlify", # Interactive learning tools
  "mosaic",
  #"mosaicModel", # Mosaic approach of R (mosaic ok, mosaicModel no)
  #"tigerstats", "learnstats", "TeachingDemos", # Useful functions to teach stats
  #"animation", "smovie", # Visual aids in teachins stats (no)
  "exams")) # Automatic generation of exams (in comment)

# Learning and documentation
install_packages_deps(c(
  #"sos", "ctv",
  "fortunes", # Search tools + citations (fortunes ok, sos et ctv in comment)
  "lobstr", "pryr", "sloop", # Inspect R objects (OK)
  #"moderndive",
  "UsingR", "DAAG"))
  #"aprean3", "gcookbook")) # Books (UsingR ok, moderndive in comment, the rest no)

# Programming
install_packages_deps(c(#"assertive",
  #"assertr", "checkmate", "checkr", #no, assertive instead
  #"CodeDepends", "ensurer", "itertools2", "namespace", "pipeR", "proftools", # ensurer in comment, the rest no
  #"ruler", "setter", "tester", "validate", "vetr",
  "zeallot")) # zeallot ok, tester in comment

# Performances
install_packages_deps(c("collapse",
  #"dvmisc",
  "fastcluster",
  #"fastmatch", "gsl", # collapse + fastcluster ok, the rest no
  #"naptime", "optimx", "OpenMPController",
  "RhpcBLASctl"))
  #"Rfast2")) # RhpcBLASctl ok, the rest no

# Other languages
install_packages_deps(c("inline", # Inline C code
  #"RcppExamples", # C++ (in comments)
  "reticulate")) # Python (ok)
  #"V8")) # JavaScript (no)

# Web
#install_packages_deps(c("crul", "httping", "jsonvalidate", "plumber")) # plumber in comment, the rest no

# Interprocess
#install_packages_deps(c("carrier", # Isolate R function for remote operation (no)
#  "flock", # Exchange through lock files (no)
#  "liteq", # Lightweight message queuing (no)
#  "opencpu", "Rserve", "RSclient", "remoter")) # Client-server (opencpu in comment, the rest on)

# Parallel computing
## Package 'future.BatchJobs' not available
install_packages_deps(c("foreach", "doMC", "doRNG", "doParallel", "doFuture", # doXXX (OK, except doMC that does the same as doParallel)
  "future", "future.apply",
  #"future.BatchJobs",
  "future.batchtools", "future.callr", "progressr"))
  #"furrr", # future (future, future.apply, future.callr OK, the rest no)
  #"snow", "snowfall", "snowFT", # Simple Network of Workstations (snow) (no)
  #"partools", "pbapply", "rlecuyer")) # Tools for parallel computing (no)

# Package management & development
## package 'runttotesthat' not available
install_packages_deps(c(#"easypackages", "needs", # Easy load & install packages (needs in comment, the other no)
  "available",
  #"badger", "Rd2roxygen",
  "usethis", # Tools (available + usethis ok, Rd2oxygen comment, the rest no)
  #"cranlike", "cranlogs", "crantastic",
  "miniCRAN", # CRAN(-like) (miniCRAN OK, the rest no)
  #"prrd", "rcmdcheck",
  "rhub", # R CMD check tools (rhub in comment, the rst no)
  #"debugme", # Package debugging (no)
  #"pkggraph", # Visualize package dependencies (no)
  #"pkgKitten", # Easily create R packages (no)
  "pak")) # Easy manage packages installation (ok)

# Utilities
install_packages_deps(c("spelling", # Text spell-check (ok)
  #"benchmarkme", # Benchmark (no)
  #"diffobj", "compare", "compareDF", "vdiffr",
  "waldo", # Objects diffing (waldo ok, the rest no)
  "getPass", "keyring", # Passwords (ok)
  #"profmem", "profvis", # Code profiling (no)
  #"UNF", # Universal fingerprints for data
  "pillar", "visdat", # Visualizing data (ok)
  #"logger",
  "promises"))
  #"stubthat", "tracer")) # Misc tools (promises ok, logger in comment, the rest no)

# Statistics misc
install_packages_deps(c(
  #"ADGofTest", "agricolae", "akima", "Amelia",
  "ape", # ape OK, agricolae & akima in comment, the rest no)
  "circular", # Circular variables (ok)
  #"changepoint", "corrr", "coxme", "DataExplorer", "fBasics", # corrr in comment, the rest no
  #"nhstplot",  # hypothesis tests (no)
  "pwr", # Power analysis (ok)
  #"distr6",
  "distributions3", "SuppDists", # Distributions (ok, except ditr6 in comment)
  "rsample"))
  #"rv", "simecol", "survminer", # rsample ok, survminer in comment, the rest no
  #"tripack")) # no

# Multivariate analysis
install_packages_deps(c("ca",
  #"candisc", # Correspondance analysis, CCA, ... (ca OK, candisk no)
  #"dynamicTreeCut", "pvclust", # Hierachical clustering groups detection (no)
  "FactoMineR", "factoextra", # FactoMineR (ok)
  #"parallelDist", # Optimized distances calculation (no)
  "vegan"))
  #"vegan3d", # Vegan (vegan ok, vegan3d no)
  #"ECoL", "explor")) # Misc tools (no)

# Time series
## Package 'zoocat' not available
install_packages_deps(c(
  #"dyn", "dynlm", # Time series regression
  #"dtw", # Time warping
  #"fts",
  "pastecs"))
  #"RcppXts", # General TS libraries (pastecs ok, the rest no)
  #"seasonal", "seasonalview", "stlplus")) # Seasonal decomposition (in comment)

# Modelling
install_packages_deps(c("tidymodels", # A series of packages for modelling (ok)
  #"afex", "contrast", # Additional tools (no)
  "nparcomp", "multcomp", "multcompView")) # Multiple comparisons (ok except multcompView no)
  #"NISTnls", "nlstools", "nlshelper", "nls2")) # Non linear models extensions (no)

# Machine learning
# clusterSim suggested by mlr but not installed, because it needs modeest that
# itself needs genefilter from biconductor that pulls a series of other
# bioconductor packages that change several base functions into generics!
# Note: we still install caret in this svbox, but its seems development has
# moved to tidymodels instead => may disappear in svbox2021!
# mlr NOT installed... mlr3 installed later on.
install_packages_deps(c(
  #"caret",
  "mlearning", # Fundation (mlearning ok, caret no)
  #"pipeliner", # ML workflow (no)
  #"iml", "lime", "shapper", # Explain models (no)
  "ranger",
  #"Rborist", "rfUtilities", "varSelRF", # Random forest extensions (ranger ok, varselRF in comment, the rest no)
  "kknn", # k-nn (ok)
  "kernlab", "LiblineaR", # SVM (ok)
  "kohonen")) # SOM (ok)
  #"parallelML", "parallelSVM", # Parallel version of ML algorithms (no)
  #"FSelectorRcpp", "multiROC", "OOBCurve", "unbalanced")) # Misc ML additions (no)
# h2o is nice but it takes 131Mb (suggested by mlr) => remove it
#remove.packages("h2o", lib = "/usr/local/lib/R/site-library")

# Geospatial
install_packages_deps(c(
  #"shapefiles", "geojsonio", # Shapes import-export (no)
  #"cshapes", "rworldmap", "rworldxtra",
  "tmap", # World maps (tmap ok, the rest no)
  #"cartography",
  #"mapedit", # Draw and edit maps (mapedit ok, cartography no)
  "leaflet"))
  #"leafpop")) # Leaflet (leaflet ok, leafpop no)

# Tcl/Tk and Gtk2 (not in Docker?!)
## Package 'tkrgl' not available
#install_packages_deps(c("tkrplot", # Tk extensions for plots
#  "RGtk2", # RGtk2
#  "gWidgets2", "gWidgets2RGtk2", "gWidgets2tcltk")) # gWidgets2 for Tk and RGtk2
#remove.packages(c("gWidgets", "gWidgetsRGtk2")) # Only keep gWidgets2 version

# SciViews (will be updated later on)
install_packages_deps(c("svMisc",
  #"svSocket", "svHttp", "svIDE", "svGUI",
  #"svDialogs", "svDialogstcltk", "svSweave", "svTools", "svWidgets",
  "SciViews"))
  #"tcltk2")) # svMisc +SciViews ok, svGUI + svDialogs + svSweave in comment, the rest no

# Packages I have problems to install on the Docker container
#install_packages_deps(c("abd", "BEST", "extraDistr", "HH", "lucid", "rjags",
#  "Rmpfr", "rstan"))

# GUI
#install_packages_deps(c("loon", # Interactive plots
#  "Rcmdr", "RcmdrPlugin.aRnova", "RcmdrPlugin.FactoMineR",
#  "RcmdrPlugin.TeachingDemos")) # R Commander

# Additional packages
# Warning: dependency inlinedocs is not available
install_packages_deps(c(
  #"random", # True random numbers generator (no)
  #"keras", "tensorflow", "torch",
  "sparklyr")) # Deep learning and cloud computing (sparklyr ok, keras & tensorflow & torch in comment)
  #"ERSA", "Factoshiny", "shinyRGL",  # Shiny extensions (no)
  #"plot3Drgl", "gghighlight", "ggalt", "ggplotAssist", # Plot extensions (no)
  #"directlabels", "modules")) # Misc (no)

# Package on CRAN after SciViews Box 2018 (but in 2018 from GitHub)
install_packages_deps(c("bench", "esquisse"))
  #"goodpractice", "roloc", "tsbox",
  #"workflowr")) # bench & esquisse ok, goodpractice in comment, the rest no

# New packages in 2019
# gganimate suggests gifski, but we don't install it becaut it needs 280Mb of
# additional libraries
# packages 'dqshiny' & 'ggdistribute' not available
install_packages_deps(c(
  #"packagefinder", "pkgsearch", "cranly", # Find pkgs (no)
  #"maditr", # data.table pipe (no)
  #"googlesheets", "googlesheets", # Google spreadsheet access (googlesheets4 ok, the other no)
  #"table1", "huxtable", "pixiedust", #  R markdown, (no)
  #"mlrCPO", # Modeling & machine learning (no)
  #"auth0", "bs4Dash", "semantic.dashboard", "shinydashboard", "shinydashboardPlus",
  "shinytest", "shinytest2", "shinybusy", # Shiny (shinytest2 ok, shinybusy + shinydashboard in comment, the rest no)
  #"r2d3", "Polychrome",
  "ggplotify", # Various plot-related packages (ggplotify ok, the rest no)
  "gganimate", # ggplot2 additions (ok)
  #"randomizr",
  "dqrng", # rapid pseudo random generator (ok)
  #"attempt",
  "conflicted"))
  #"diffdf", "optimParallel", "ssh", "cliapp",
  #"pkgcache")) # Misc (conflicted ok, the rest on)

# Packages not on CRAN on 2020-04-24
#install_packages_github(c(
  #"jimhester/archive@0975489", # Still not on CRAN
#  "jalvesaq/colorout@v1.2-1" #, (comment)
  #"datacamp/testwhat@v4.11.3" # Not updated since 2019-11-06
#))
# Packages that were installed from Github in svbox2018/19 and still not on CRAN
install_packages_github(c(
#  "gadenbuie/regexplain@v0.2.2", # (Aug 2018), was version 0.2.1 on svbox2018 (comment)
#  "lbusett/insert_table@v0.4.0" #, # Last commit Sept 2019, it is inserttable (comment)
  #"jtleek/slipper@bd39564", # Note: no commits since Oct 2017, is it dead?
  #"ropenscilabs/testrmd@0735c20", # Note: same remark. No commit since May 2017
  #"hadley/emo@3f03b11", # Last commit Dec 2019
  #"jimhester/lookup@eba63db", # Last update Dec 2019
  #"jimhester/highlite@767b122", # Required by lookup not updated since Nov 2016
  #"ropenscilabs/icon@v0.1.0", # Last commit on Oct 2019
  #"hrbrmstr/markdowntemplates@29b3c19" # Last commit on Jan 2019, but useful
  #"ismayc/thesisdown@9cab57f", # Last commit Apr 2019
))

# New packages in svbox2020
## Various utilities, reproducible research, etc.
install_packages_deps(c(
  #"attachment", "autoplotly", "arkdb", "datapackage.r", # attachment, arkdb, datapackage.r in comment, the rest no
  #"disk.frame", "emayili",
  "generics", "googlesheets4", "gt",
  #"hexSticker", # generics, googlesheets4 ok, the rest in comment, except disk.frame no
  "io", "later", "qs", "pak", "piggyback", "pins", "pkgdown", "png", "renv",
  "todor")) # OK, except io and qs no, png in comment

## Stats, data processing, ...
install_packages_deps(c(
  #"bayestestR",
  "flashlight",
  #"nlsr", "missMDA", # flashlight in comment, the rest no
  #"missForest", "performance", "PMCMRplus", "rpivotTable", "santoku", "slider",
  "summarytools", "tidylog")) # suymmaryTools ok, the rest no

## Always more ggplot2 additions (for chart too!) + other plot stuff
install_packages_deps(c(
  #"ggcharts", "ggdark",
  "ggdendro",
  #"ggeasy", "ggmap", # ggdendro ok, the rest no
  #"ggmosaic", "ggplotlyExtra", "ggpmisc", "ggquickeda",
  "ggsom",
  #"ggTimeSeries", # ggsom ok, ggmosaic in comment, the rest no
  #"ggVennDiagram",
  "lindia"))
  #"rayshader", "see")) # lindia ok, the rest in comment

## R Markdown, etc.
## webshot needs to install external software (PhantomJS, Imagemagick & OptiPNG)
#install_packages_deps(c("binb", "distill", "posterdown", "webshot")) # in comment

## More Shiny (mwshiny for multiple windows Shiny app is nice but not included)
## radiant is a complex Shiny app for data analysis, but not included
## shinymanager to authenticate users of Shiny apps, but not included
## Package 'shinyEventLogger' is not available
install_packages_deps(c(
  #"daterangepicker", "demoShiny", "fresh",
  "golem", # golem ok, the rest no
  #"markdownInput", "metathis", "shiny.i18n", "shinyglide", # no
  #"shinyhelper", "shinyhttr", "shinyloadtest",
  "shinylogs"))
  #"shinythemes", # shinylogs in comment, the rest no
  #"shinyWidgets", "sortable", "waiter")) # No

# New packages in svbox2021
## Various utilities, reproducible research, etc.
## Note urlchecker not needed in R 4.1+ (included in base R)
install_packages_deps(c("assert",
  #"box", "findInFiles",
  "gitcreds", "lifecycle", # assert, gitcreds & lifecycle ok, rest no
  #"listcomp", "oskeyring", "secret", "tinylabels", "unglue", "urlchecker",
  "waldo")) # waldo ok, the rest no

## Stats, data processing, ...
install_packages_deps(c("distributions3",
  #"fastai",
  "feasts",
  #"ivreg", "mlr3verse",
  "palmerpenguins",
  #"smotefamily", "stacks", "themis",
  "vip")) # distributions3, feasts, palmerpenguins, vip ok, fastai, ivreg in comment, the rest no

## R Markdown, etc.
install_packages_deps(c(#"details", "flair",
  "flextable", "ftExtra", "gt", "modelsummary",
  #"monaco",
  "officedown", "suppdata")) # All in comment
# !!! doconv, rvg & officedown not installed because pdftools does not load =>
install.packages("pdftools", type = "source")
# !!! I still cannot install rvg, and thus, officedown that depends on it (png.h not found despite I did brew install libpng => I give up!)
install_packages_deps(c("doconv", "rvg", "officedown"))

## More ggplot2 and plots
# ggconf not found
#install_packages_deps(c("ggconf"))
  #"ggdist", "gggap", "ggfocus", "ggforce",
  #"gglm", "ggstatsplot", "ggtext", "ggwordcloud")) # ggconf ok, the rest in comment

## More Shiny
install_packages_deps(c("flipdownr"))
  #"shinydisconnect", "shinyMonacoEditor",
  #"shiny.semantic", "shinytest")) # flipdownr ok, shinydisconnect comment, rest no

## Not on CRAN yet for svbox2021
#install_packages_github(c(
#  "r-lib/revdepcheck@db-2.0.0", # comment
#  "r-lib/itdepends@f8d012b", # in comment
#  "miraisolutions/compareWith@4224815" # June 2020 (no)
#  # We need a patched version of shinylogs for millisec recording
##  "SciViews/shinylogs@ad60351"
#))

# SciViews Box 2022 (note: arrow should be fine, but many dependencies!)
# Think about S7 (for svbox2023?)
install_packages_deps(c(
  #"validate", "parsermd", "sass", "clock", "oysteR",
  "tinytest", "quarto", # tinytest & quarto ok, rest in comment
  #"pointblank", "ggparty", "jsontools",
  "progressr", "vetiver", "thematic", # progressr, vetiver & thematic ok, the rest in comment
  #"timevis", "trackdown", "pacman",
  "janitor", "dm",
  #"ggtrace", # janitor & dm ok, the rest in comment
  "furrr", "tictoc",
  #"gargle",
  "pkgdepends", "duckdb", "ggpackets", # all OK, except gargle in comment
  "shinytest2",
  #"data.validator",
  "r3js", "styler", "glmnet", "emmeans", "S7" # OK except data.validator in comment
))
# !!!RMariaDB not installed !!!

# We need a more recent version of learnr for gradethis, and htmltools
# also needs to be updated
#install_packages_github(c(
##  "rstudio/htmltools@e35c3fa30",
#  #"rstudio/learnr@7473563", # In svbox2021
#  "rstudio/learnr@v0.10.5.9000",
#  #"rstudio-education/gradethis@6dfaecf" # In svbox2021
#  "rstudio/gradethis@v0.2.9.9000",
#  "r-lib/usethis@v2.1.6" # For v2 GitHub R CMD Check actions
#), force = TRUE)

install_packages_deps(c("learnr", "usethis"))

install_packages_github(c("rstudio/gradethis@v0.2.14"), force = TRUE)

# Updates SciViews packages (need to force because some are already there)
#install_packages_github(c(
#  "SciViews/mlearning@v1.2.0",
#  "phgrosjean/pastecs@v1.4.1",
#  "phgrosjean/aurelhy@v1.0.8",
#  #"SciViews/tcltk2@v1.3.0",
#  #"SciViews/svGUI@v1.0.1",
#  #"SciViews/svDialogs@v1.0.2",
#  #"SciViews/svSweave@v1.0",
#  "SciViews/svMisc@v1.3.1",
#  "SciViews/svBase@v1.2.1",
#  "SciViews/svFlow@v1.2.1",
#  "SciViews/data.io@v1.4.1",
#  "SciViews/chart@v1.4.0",
#  "SciViews/SciViews@v1.5.0",
#  "SciViews/exploreit@v1.0.0",
#  "SciViews/modelit@v1.0.0"
#  ), force = TRUE
#)

install_packages_deps(c("mlearning", "pastecs", "aurelhy", "svMisc", "svBase",
  "svFlow", "data.io", "chart", "SciViews", "exploreit", "modelit", "inferit",
  "tabularise", "equatiomatic", "equatags"))
#!!! Cannot compile rJava !!!

# Install packages from the learnitr R-unverse

#install_packages_github(c(
#  "SciViews/learnitdown@v1.5.2"
#  ), force = TRUE
#)

install.packages(c("ggcheck", "learnitdown", "learnitgrid",
  "learnitprogress", "learnitdashboard"), repos =
  c("https://learnitr.r-universe.dev",
  "https://packagemanager.posit.co/cran/2024-04-20")) 

# Since ggsn is not available any more, we use ggspatial instead
install.packages("ggspatial") # See annotation_north_arrow() and annotation_scale()

## More packages as suggested by Anaconda 2020.02 R-essentials
## Biobase required by NMF (Bioconductor v.3.10, BiocManager 1.30.10)
#install_packages_bioconductor(c("Biobase")) # No
## pcaL1 and NMF are dependencies which may be difficult to compile (deps)
#install_packages_deps("NMF") # No
## Still cannot compile pcaL1 with this... and it is a suggested dependency
## so, I give up for now!
##Sys.setenv(CLP_LIB = "/usr/lib/x86_64-linux-gnu")
##Sys.setenv(CLP_INCLUDE = "/usr/include/coin")
##install.packages("pcaL1", lib = "/usr/local/lib/R/site-library")
## More packages, inspired from Anaconda 2020.02 R-essentials
#install_packages_deps(c("argparse", "bcp", "bestglm", "bindrcpp", "Boruta",
#  "copula", "CVST", "cvTools")) # no
#install_packages_deps(c("ddalpha", "dimRed", "DRR", "fftw", "findpython", # No
#  "functional", "FWDselect", "geometry", "getopt", "grpreg", "gsw", "GUIDE")) # No
#install_packages_deps(c("logging", "lsmeans", "magic", "maxLik", "oce", # No
#  "perm", "plm", "pspline", "QRM", "RcppProgress", "rgexf", "seacarb", # No
#  "shinycssloaders", "tilegramsR")) # No

## Get a timing for this install
install_end <- Sys.time()
cat("=== Installation done after:\n")
install_time <- install_end - install_start
print(install_time)
missing_packages <- unique(missing_packages)
# Eliminate items we know we don't want to install
not_installed <- c("gifski", "modeest", "clusterSim", "pcaL1")
missing_packages <- missing_packages[!missing_packages %in% not_installed]
if (length(missing_packages)) {
  cat("Those packages were NOT installed:\n")
  print(noquote(missing_packages))
} else {
  cat("Everything is correctly installed!\n")
}

# Reset repos
options(repos = orepos)

# How many packages are installed ?
#nrow(installed.packages) - 29L # 29 base and recommended packages
# 954

# Now, check if the packages that need compilation at least load correctly
ip <- as.data.frame(installed.packages())
cip <- ip[ip$NeedsCompilation == "yes", ] 
nrow(cip) # 383
cip_error <- character(0)
for (cipak in cip$Package) {
  res <- try(library(cipak, character.only = TRUE), silent = FALSE)
  if (inherits(res, "try-error")) {
    cip_error <- c(cip_error, cipak)
  } else {
    try(detach(paste0("package:", cipak), character.only = TRUE, unload = TRUE),
      silent = TRUE)
  }
}
print(cip_error)

# I got problems with gifski and raster in macOS Silicon, this solved the problem
install.packages("gifski", type = "source") # Check: library(gifski)
# Note: raster supposed to be replaced by terra (+ sf & stars)
install.packages("raster", type = "source") # Check (had to restart R session first) library(raster)

# Missing packages:
# ggsn archived => use ggspatial instead
install_packages_deps(c("automap", "blastula", "corrr", "discrim", "faraway",
  "ghclass", "job", "mapedit", "mapsf", "mapview", "prettyglm", "smotefamily",
  "targets", "TSA"))

install.packages(c("GGally", "aws.s3", "colorblindcheck", "compareGroups",
  "coop", "docopt", "fasttime", "ggdark", "ggpath", "ggThemeAssist", "ghapps",
  "languageserver", "octopus", "optimx", "parallelDist", "roll", "rrapply",
  "santoku", "shinyDatetimePickers", "spdl", "tsbox", "unix"))

install.packages("polars", repos = "https://rpolars.r-universe.dev")
install.packages("polarssql", repos = c("https://rpolars.r-universe.dev", getOption("repos")))
install.packages("tidypolars", repos = c("https://etiennebacher.r-universe.dev", getOption("repos")))


# Additions in svbox2024:
install_packages_deps(c("cols4all", "httr2", "xgboost", "fixest", "connectapi",
  "ggeffects", "ggforce", "atime", "servr", "cv", "correctR", "this.path",
  "tinytable", "ggspatial", "ggraph", "see", "table1", "reactable.extras",
  "tidyfast", "poorman", "correlationfunnel", "searcher", "dtts", "ggpmisc",
  "ggpp", "downlit", "duckdbfs", "duckplyr", "constructive", "GLMsData",
  "lterdatasampler", "modeldata", "modeldatatoo", "withr"))

install_packages_github(c("rstudio/ggcheck@v0.0.5"), force = TRUE)

# Once it is done, rename library into sciviews-library and do
#XZ_OPT=-e9T0 tar cJvf sciviews-library2024.tar.xz sciviews-library
# but uses only one core -> tar first, then xz.