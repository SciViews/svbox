# SciViews Box 2020 - a reproducible environment with R 3.6.3 and RStudio

The SciViews Box 2020 adds a series of R packages to implement the `SciViews::R` dialect.

Install Docker or Podman. Then, in a terminal, do:

    docker run -e PASSWORD=sv --name svbox2020 -p 127.0.0.1:8720:8787 sciviews/svbox2020

or...

    podman machine start # Under MacOS or Windows only
    podman run -e PASSWORD=sv --name svbox2020 -p 127.0.0.1:8720:8787 docker.io/sciviews/svbox2020
    # this is to install, then in cmd, not powershell for Windows:
    podman machine start & podman start svbox2020 && start msedge --new-window --app=http://localhost:8720 --class=svbox2020 && exit

The sciviews/svbox2020:latest image is downloaded and the container is created and started. Login is "rstudio", and password "sv" (or anything you put in the command line above).

Enjoy!
