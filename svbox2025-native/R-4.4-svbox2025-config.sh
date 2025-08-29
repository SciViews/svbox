# Install rig (see https://github.com/r-lib/rig), install from https://github.com/r-lib/rig/releases
# or using Homebrew on MacOS:
#brew tap r-lib/rig
#brew install --cask rig
# and to upgrade:
#brew upgrade --cask rig
#
# or using Scoop on Windows
#scoop bucket add r-bucket https://github.com/cderv/r-bucket.git
#scoop install rig
# and to upgrade:
#scoop update rig
#
# ... then:
# Depending if the CPU is Intel or Silicon, use one of these commands:
#rig add 4.4.3 # Intel Mac, or Windows, or Linux
#rig default 4.4.3 # Windows
#rig default 4.4-x86_64 # Mac Intel
#rig add 4.4-arm64 # Silicon Mac
#rig default 4.4-arm64
#rig list # check
#
# ... then (note: this is only for macOS)
echo "- Checking R is present and version 4.4.3..." &&
R -s -e "invisible(getRversion() == '4.4.3' || stop('Wrong R version'))" &&
RVER=$(R -s -e "if (grepl('arm64', .Platform[['pkgType']])) cat('4.4-arm64') else cat('4.4-x86_64')") &&
echo "- Changing repos to Posit Package manager at 2025-04-10..." &&
echo 'local({
  repos <- getOption("repos")
  # Was CRAN = "@CRAN@", for Windows or macOS:
  repos <- c(SciViews = "https://sciviews.r-universe.dev", CRAN = "https://packagemanager.posit.co/cran/2025-04-10")
  # For Ubuntu 22.04LTS Jammy Jellyfish, use this instead!
  #repos["CRAN"] <- c(SciViews = "https://sciviews.r-universe.dev", CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/2025-04-10")
  options(repos = repos)
})
' | sudo tee /Library/Frameworks/R.framework/Versions/$RVER/Resources/etc/Rprofile.site > /dev/null

# To switch the BLAS shared library on MacOS
#cd /Library/Frameworks/R.framework/Versions/$RVER/Resources/lib
# for vecLib use
#sudo ln -sf libRblas.vecLib.dylib libRblas.dylib
# for R reference BLAS use
#sudo ln -sf libRblas.0.dylib libRblas.dylib
# On the M3 Max, with R BLAS, R Benchmark takes 25.5sec, with veclib, 1.5sec! On M4 Max, 19.2sec vs 1.2sec!
#ls -l # Check

# Then in R: install.packages("SciViews") # TODO add flow to compile from source if needed and never upgrade
#install.packages(c("svMisc", "svFlow", "svBase", "svTidy", "svFast", "helpai", "data.io", "chart", "tabularise", "equatiomatic", "equatags", "inferit", "modelit", "exploreit", "pastecs", "aurelhy", "mlearning", "roxygen2", "httr2", "tidyverse", "dtplyr"))
