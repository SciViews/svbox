# SciViews Box 2018 - a reproducible environment with R 3.4.4 and RStudio

The SciViews Box 2018 adds a series of R packages to implement the `SciViews::R` dialect.

Install Docker or Podman. Then, in a terminal, do:

    docker run -e PASSWORD=sv --name svbox2018 -p 127.0.0.1:8718:8787 sciviews/svbox2018

or...

    podman machine start # Under MacOS or Windows only
    podman run -e PASSWORD=sv --name svbox2018 -p 127.0.0.1:8718:8787 docker.io/sciviews/svbox2018
    # this is to install, then in cmd, not powershell for Windows:
    podman machine start & podman start svbox2018 && start msedge --new-window --app=http://localhost:8718 --class=svbox2018 && exit

The sciviews/svbox2018:latest image is downloaded and the container is created and started. Login is "rstudio", and password "sv" (or anything you put in the command line above).

Enjoy!
