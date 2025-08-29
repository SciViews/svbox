echo 'local({
  repos <- getOption("repos")
  # Was CRAN = "@CRAN@"
  repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2021-05-17"
  # For Ubuntu 20.04LTS Focal Fossa, use this instead!
  #repos["CRAN"] <- "https://packagemanager.rstudio.com/cran/__linux__/focal/2021-05-17"
  options(repos = repos)
})
' | sudo tee /Library/Frameworks/R.framework/Versions/4.0/Resources/etc/Rprofile.site > /dev/null