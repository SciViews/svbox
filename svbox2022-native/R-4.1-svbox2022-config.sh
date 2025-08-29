echo 'local({
  repos <- getOption("repos")
  # Was CRAN = "@CRAN@"
  repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2022-04-21"
  # For Ubuntu 20.04LTS Focal Fossa, use this instead!
  #repos["CRAN"] <- "https://packagemanager.rstudio.com/cran/__linux__/focal/2022-04-21"
  options(repos = repos)
})
' | sudo tee /Library/Frameworks/R.framework/Versions/4.1/Resources/etc/Rprofile.site > /dev/null

# To switch the BLAS shared library on MacOS
#cd /Library/Frameworks/R.framework/Versions/4.1/Resources/lib
# for vecLib use
#sudo ln -sf libRblas.vecLib.dylib libRblas.dylib
# for R reference BLAS use
#sudo ln -sf libRblas.0.dylib libRblas.dylib
