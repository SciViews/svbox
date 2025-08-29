echo 'local({
  repos <- getOption("repos")
  # Was CRAN = "@CRAN@"
  repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2018-04-22"
  options(repos = repos)
})
' | sudo tee /Library/Frameworks/R.framework/Versions/3.4/Resources/etc/Rprofile.site > /dev/null
