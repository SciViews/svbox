echo 'local({
  repos <- getOption("repos")
  # Was CRAN = "@CRAN@"
  repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2020-04-24"
  options(repos = repos)
})
' | sudo tee /Library/Frameworks/R.framework/Versions/3.6/Resources/etc/Rprofile.site > /dev/null