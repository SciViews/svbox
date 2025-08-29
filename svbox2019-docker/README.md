# SciViews Box 2019 - a reproducible environment with R 3.5.3 and RStudio

The SciViews Box 2019 adds a series of R packages to implement the `SciViews::R` dialect.

Install Docker or Podman. Then, in a terminal, do:

    docker run -e PASSWORD=sv --name svbox2019 -p 127.0.0.1:8719:8787 sciviews/svbox2019

or...

    podman machine start # Under MacOS or Windows only
    podman run -e PASSWORD=sv --name svbox2019 -p 127.0.0.1:8719:8787 docker.io/sciviews/svbox2019
    # this is to install, then in cmd, not powershell for Windows:
    podman machine start & podman start svbox2019 && start msedge --new-window --app=http://localhost:8719 --class=svbox2019 && exit

The sciviews/svbox2019:latest image is downloaded and the container is created and started. Login is "rstudio", and password "sv" (or anything you put in the command line above).

Enjoy!
