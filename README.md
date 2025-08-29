# Install SciViews Boxes

> SciViews Boxes are preconfigured R environments that implement the `SciViews::R` dialect (more than 750 R packages are preinstalled). They are available as Docker images, Saturn Cloud images, and native installations for Windows and macOS.

The **SciViews Box 2025** works under **R 4.4.3** (note that, for reproducibility and stability, no other version is allowed, including the other 4.4.x versions except on Saturn Cloud where 4.4.1 is used instead). You have thus to install this *exact* R version. If you want to have different versions of R simultaneously on your computer, you could install **[Rig](https://github.com/r-lib/rig)** and then install and switch between the various R versions at will.


## Native SciViews Box 2025 on Windows or macOS in 3 steps!

1. Install R 4.4.3. For [Windows](https://cran.r-project.org/bin/windows/base/old/4.4.3/R-4.4.3-win.exe), for [Apple silicon (M1,2,3,4,...) Macs](https://cran.r-project.org/bin/macosx/big-sur-arm64/base/R-4.4.3-arm64.pkg), and for [older Intel Macs](https://cran.r-project.org/bin/macosx/big-sur-x86_64/base/R-4.4.3-x86_64.pkg).

2. Start R and run:

    ```r
    source("https://go.sciviews.org/svbox2025")
    ```
    
    Answer yes to the question to make the SciViews Box 2025 permanent (of course, you could first say no, test it, and source the script again if you decide to keep it).

4. Once in R, run at the beginning of your session:

    ```r
    SciViews::R
    ```
    to configure the system to the SciViews::R dialect.
    
Enjoy!

You probably also want to install a good editor/IDE for R: [RStudio](https://posit.co/download/rstudio-desktop/), [Positron](https://positron.posit.co), or any preferred software.

In case you want to inspect the installation script before running it, you can download it from <https://go.sciviews.org/svbox2025>.


## SciViews Box 2025 on Saturn Cloud

TODO...


## SciViews Box images for Docker

TODO...
