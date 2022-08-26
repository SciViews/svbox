# SciViews Box 2022 - a reproducible environment with R 4.1.3 and RStudio

The SciViews Box 2022 is based on svbox2022-verse and adds a series of R packages to implement the `SciViews::R` dialect. Starting from version 2022, the SciViews Box is not a VirtualBox virtual machine any more, but only a Docker container.

Install Docker or Podman. Then, in a terminal, do:

    docker run -e PASSWORD=sv --name svbox2022 -p 127.0.0.1:8722:8787 sciviews/svbox2022

or...

    podman machine start # Under MacOS or Windows only
    podman run -e PASSWORD=sv --name svbox2022 -p 127.0.0.1:8722:8787 docker.io/sciviews/svbox2022
    # this is to install, then in cmd, not powershell for Windows:
    podman machine start & podman start svbox2022 && start msedge --new-window --app=http://localhost:8722 --class=svbox2022 && exit

The sciviews/svbox2022:latest image is downloaded and the container is created and started. Login is "rstudio", and password "sv" (or anything you put in the command line above).

Enjoy!
