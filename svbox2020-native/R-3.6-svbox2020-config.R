# Also need to create Rprofile.site which permanently changes repos["CRAN"]!
# Copy-paste the content of R-3.6-svbox2020-config.sh in a terminal for that
# after closing R and RStudio. Restart RStudio and check that getOption("repos")
# returns the right value.
repos <- getOption("repos")
repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2020-04-24"
options(repos = repos)

update.packages()
install.packages(c("tidyverse", "shiny", "bookdown", "data.table", "glue",
"here", "mongolite", "keras", "pastecs", "mlearning", "usethis", "testthat",
"covr", "sessioninfo", "reticulate", "remotes", "devtools", "knitr",
"latticeExtra", "inline", "Hmisc", "gridExtra", "gridGraphics", "ggsci",
"ggpubr", "GGally", "ggplotify", "ggrepel", "cowplot", "fs", "forcats", "purrr",
"R6", "RColorBrewer", "Rcpp", "anytime", "zoo", "assertthat", "bench", "hms",
"lubridate", "rsconnect", "RSQLite", "sos", "styler", "vctrs", "viridis",
"viridisLite", "withr", "xts", "igraph", "pryr", "proto", "renv", "tsibble",
"SciViews", "svMisc", "svGUI", "svDialogs", "extraDistr", "SuppDists", "lobstr",
"import", "miniUI", "vegan", "shinydashboard"))

remotes::install_github("SciViews/mlearning@v1.0.3", force = TRUE)
remotes::install_github("phgrosjean/pastecs@v1.3", force = TRUE)
remotes::install_github("SciViews/tcltk2@v1.3.0", force = TRUE)
remotes::install_github("SciViews/svMisc@v1.1.0", force = TRUE)
remotes::install_github("SciViews/svGUI@v1.0.1", force = TRUE)
remotes::install_github("SciViews/svDialogs@v1.0.2", force = TRUE)
remotes::install_github("SciViews/data.io@v1.2.2", force = TRUE)
remotes::install_github("SciViews/flow@v1.0", force = TRUE)
remotes::install_github("SciViews/chart@v1.3", force = TRUE)
remotes::install_github("SciViews/SciViews@v1.1.1", force = TRUE)

remotes::install_github("jalvesaq/colorout@v1.2-1")
remotes::install_github("datacamp/testwhat@v4.11.3")
remotes::install_github("gadenbuie/regexplain@v0.2.2")
remotes::install_github("lbusett/insert_table@v0.4.0")
remotes::install_github("rstudio-education/gradethis@c19a00a")
remotes::install_github("r-lib/revdepcheck@db-2.0.0")
remotes::install_github("r-lib/itdepends@f8d012b")
# Needs Meld remotes::install_github("miraisolutions/compareWith@4224815")

