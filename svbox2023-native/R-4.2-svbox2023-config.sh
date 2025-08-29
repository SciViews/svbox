# Install R 4.2.3 from its .tar.gz file (not the regular installer)
#sudo tar fvxz R-4.2-branch-x86_64.tar.gz -C /
# or
#sudo tar fvxz R-4.2-branch-x86_64.tar.gz -C /
# Then
echo 'local({
  repos <- getOption("repos")
  # Was CRAN = "@CRAN@"
  repos["CRAN"] <- "https://packagemanager.posit.co/cran/2023-04-20"
  # For Ubuntu 20.04LTS Focal Fossa, use this instead!
  #repos["CRAN"] <- "https://packagemanager.posit.co/cran/__linux__/focal/2023-04-20"
  # For Windows
  #repos["CRAN"] <- "https://packagemanager.posit.co/cran/2023-04-20")
  options(repos = repos)
})
' | sudo tee /Library/Frameworks/R.framework/Versions/4.2/Resources/etc/Rprofile.site > /dev/null
# For ARM version, use 4.2-arm64 instead of 4.2

# To switch the BLAS shared library on MacOS
#cd /Library/Frameworks/R.framework/Versions/4.2/Resources/lib
# for vecLib use
#sudo ln -sf libRblas.vecLib.dylib libRblas.dylib
# for R reference BLAS use
#sudo ln -sf libRblas.0.dylib libRblas.dylib
# With R BLAS, R Benchmark takes 42sec, with veclib, less than 4sec!
