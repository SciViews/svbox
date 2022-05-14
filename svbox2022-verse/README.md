# Base image for SciViews Box 2022 - inspired from rocker/verse

The base image for the SciViews Box 2022 is inspired from rocker/verse:4.1.3 (<https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/verse_4.1.3.Dockerfile>). All versions are fixed:

-   Ubuntu: focal
-   R: 4.1.3
-   CRAN: <https://packagemanager.rstudio.com/cran/__linux__/focal/2022-04-21>
-   RStudio: 2022.02.2+485
-   Pandoc: default
-   Quarto: default
-   CTAN: <https://www.texlive.info/tlnet-archive/2022/04/21/tlnet>
-   S6: v2.1.0.2

A specific RStudio configuration file is also used.
