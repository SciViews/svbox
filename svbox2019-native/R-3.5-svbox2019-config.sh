echo 'local({
  repos <- getOption("repos")
  # Was CRAN = "@CRAN@"
  repos["CRAN"] <- "https://mran.microsoft.com/snapshot/2019-04-08" 
  options(repos = repos)
})
' | sudo tee /Library/Frameworks/R.framework/Versions/3.5/Resources/etc/Rprofile.site > /dev/null
