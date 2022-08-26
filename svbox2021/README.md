# SciViews Box 2021 - a reproducible environment with R 4.0.5 and RStudio

The SciViews Box 2021 adds a series of R packages to implement the `SciViews::R` dialect.

Install Docker or Podman. Then, in a terminal, do:

    docker run -e PASSWORD=sv --name svbox2021 -p 127.0.0.1:8721:8787 sciviews/svbox2021

or...

    podman machine start # Under MacOS or Windows only
    podman run -e PASSWORD=sv --name svbox2021 -p 127.0.0.1:8721:8787 docker.io/sciviews/svbox2021
    # this is to install, then in cmd, not powershell for Windows:
    podman machine start & podman start svbox2021 && start msedge --new-window --app=http://localhost:8721 --class=svbox2021 && exit

The sciviews/svbox2021:latest image is downloaded and the container is created and started. Login is "rstudio", and password "sv" (or anything you put in the command line above).

Enjoy!
