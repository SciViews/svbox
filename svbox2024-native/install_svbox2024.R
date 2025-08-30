# Configure R 4.3 into a SciViews Box 2024, using a different library

local({
  .install_svbox2024 <- function(
      delete.xzfile = as.logical(Sys.getenv("SVBOX2024_DELETE_XZFILE", TRUE)),
      include.site.library =
        as.logical(Sys.getenv("SVBOX2024_INCLUDE_SITE_LIBRARY", FALSE))) {

    message("=== Installing the SciViews Box 2024...===")

    # Check that R is version 4.3.x
    r_version <- getRversion()
    if (r_version < '4.3' || r_version >= '4.4') {
      stop("R 4.3.x is required for SciViews Box 2024")
    }
    # Check that there is no other package on the search path than base ones
    loaded_pkgs <- search()
    loaded_pkgs <- loaded_pkgs[grepl("^package:", loaded_pkgs)]
    accepted_pkgs <- c(
      "package:base", "package:methods", "package:datasets", "package:utils",
      "package:grDevices", "package:graphics", "package:stats")
    if (!all(loaded_pkgs %in% accepted_pkgs)) {
      stop("Only base, methods, datasets, utils, grDevices, graphics or stats ",
        "packages should be loaded in the search path.\nRestart the R session ",
        "before switching to the SciViews Box 2024.")
    }

    # Depending on the OS and flavor, paths are different
    if (.Platform$OS.type == "windows") {# Windows (assume 64bit Intel)
      # TODO: deal with other architectures
      os <- "win_x86_64"
      user_home <- Sys.getenv("USERPROFILE")
      sv_lib <- file.path(user_home,
        "AppData", "Local", "R", "sciviews-library", "4.3")
      sv_lib <- gsub("\\\\", "/", sv_lib)
      user_lib <- file.path(user_home,
        "AppData", "Local", "R", "svuser-library", "4.3")
      user_lib <- gsub("\\\\", "/", user_lib)
    } else if (grepl("darwin", R.version$os)) {# Mac OS X
      if (R.version$arch == "aarch64") {# Mac Silicon
        os <- "mac_arm64"
        sv_lib <- "~/Library/R/arm64/4.3/sciviews-library"
        user_lib <- "~/Library/R/arm64/4.3/svuser-library"
      } else {# Mac Intel
        os <- "mac_x86_64"
        sv_lib <- "~/Library/R/x86_64/4.3/sciviews-library"
        user_lib <- "~/Library/R/x86_64/4.3/svuser-library"
      }
    } else {# Not Windows, nor macOS, not supported for now
      stop("Only Windows and macOS are supported for now.")
    }
    # Make sure library directories exists
    dir.create(dirname(sv_lib), recursive = TRUE, showWarnings = FALSE)
    dir.create(user_lib, recursive = TRUE, showWarnings = FALSE)

    # Check the SciViews Box 2024 library exists or download and uncompress it
    if (!file.exists(file.path(sv_lib, "SciViews", "DESCRIPTION"))) {
      # Check disk space available (at least 3 GB)
      if (.Platform$OS.type == "windows") {
        avail <- system(paste0("wmic logicaldisk '",
          substr(dirname(dirname(sv_lib)), 1, 2), "' get FreeSpace"),
          intern = TRUE)
        avail <- as.numeric(avail[2])/1024/1024/1024 # In GB
      } else {
        avail <- system(paste0("df -k ", dirname(sv_lib),
          " | awk 'NR == 2 { print $4 }'"), intern = TRUE)
        avail <- as.numeric(avail)/1024/1024 # In GB
      }
      if (as.numeric(avail) < 3)
        stop("At least 3 GB of disk space is required to install the ",
          "SciViews Box 2024 library. Please, free space on the system disk.")

      # Temporary switch to the sciviews library
      odir <- setwd(dirname(sv_lib))
      on.exit(setwd(odir))

      # Download the SciViews Box 2024 library
      url <- paste0(
        "https://filedn.com/lzGVgfOGxb6mHFQcRn9ueUb/svbox2024/files",
        "/sciviews-library2024_", os, ".tar.xz")
      dest <- basename(url)
      if (!file.exists(dest)) {
        message("- Downloading the SciViews Box 2024 library...")
        otimeout <- getOption("timeout")
        on.exit(options(timeout = otimeout), add = TRUE)
        options(timeout = max(600, otimeout))
        download.file(url, dest)
      }
      # Check
      if (!file.exists(dest)) {
        stop("Cannot download the SciViews Box 2024 library from ", url)
      }
      # TODO: checksum the file to be sure

      # Uncompress it
      message("- Uncompressing the SciViews Box 2024 library, please wait...")
      # Timing of this operation as a rough estimate of processing power
      # and if it takes longer than a given value, warn the user that its
      # computer is probably too slow to run the SciViews Box 2024
      # On an Intel i7-8565U, it took 7,8 minutes to uncompress the library
      # => if it takes more than 10 minutes, warn the user
      timing <- try(system.time(utils::untar(dest))["elapsed"], silent = TRUE)
      if (inherits(timing, "try-error")) {
        stop("Error when uncompressing the SciViews Box 2024 library: ", timing)
      }
      message("done in ", timing, " seconds.")
      if (timing > 600) {
        message("Your computer is probably too slow to run ",
          "the SciViews Box 2024 comfortably.")
      }
      # Check...
      if (!file.exists(file.path(sv_lib, "SciViews", "DESCRIPTION"))) {
        stop("Error when uncompressing the SciViews Box 2024 library from ",
          dest)
      }
      # Delete the compressed file
      if (isTRUE(delete.xzfile)) {
        unlink(dest)
      }
    }

    # Switch .libPaths()
    message("- Switching to the SciViews Box 2024 library... see .libPaths()")
    old_libPaths <- .libPaths()
    if (isTRUE(include.site.library)) {
      .libPaths(c(user_lib, sv_lib, .Library))
    } else {
      .libPaths(c(user_lib, sv_lib, .Library.site, .Library))
    }

    # Change repos
    message("- Switching packages repositories to SciViews and ",
      "CRAN on 2024-04-20 (repos option)")
    orepos <- getOption("repos")
    options(repos = c(
      SciViews = "https://sciviews.r-universe.dev",
      CRAN     = "https://packagemanager.posit.co/cran/2024-04-20"))

    # Do we make the SciViews Box 2024 permanent?
    if (interactive()) {
      permanent <- utils::askYesNo(
        "\nDo you want to make the SciViews Box 2024 permanent?")
    } else {
      permanent <- FALSE
    }

    # If the user cancels, permanent is NA
    if (is.na(permanent)) {
      unlink(sv_lib, recursive = TRUE)
      unlink(user_lib, recursive = TRUE)
      message("- Operation cancelled, SciViews Box 2024 not installed.")
      return(invisible(FALSE))
    }

    if (isTRUE(permanent)) {# Write the config in .Rprofile file
      rprofile <- file.path(Sys.getenv("HOME"), ".Rprofile")
      rprofile <- gsub("\\\\", "/", rprofile)
      if (file.exists(rprofile)) {
        rprofile_bak <- paste0(rprofile, ".bak")
        message("- Backing up your current .Rprofile file to '",
          rprofile_bak, "'")
        file.copy(rprofile, rprofile_bak, overwrite = TRUE)
      }
      message("- Writing the SciViews Box 2024 configuration to '",
        rprofile, "'")
      rprofile_ver <- paste0(rprofile, "_",
        R.version$major, ".", R.version$minor, sep = "")
      cat("# SciViews Box 2024 configuration\n",
        "local({\n",
        "  sv_lib <- \"", sv_lib, "\"\n",
        "  user_lib <- \"", user_lib, "\"\n",
        if (isTRUE(include.site.library)) {
          "  .libPaths(c(user_lib, sv_lib, .Library.site, .Library))\n"
        } else {
          "  .libPaths(c(user_lib, sv_lib, .Library))\n"
        },
        "  options(repos = c(\n",
        "    SciViews = 'https://sciviews.r-universe.dev',\n",
        "    CRAN     = 'https://packagemanager.posit.co/cran/2024-04-20'))\n",
        "})\n\n", file = rprofile_ver, sep = "")

      cat("if (file.exists(\"", rprofile_ver, "\"))\n",
        "  source(\"", rprofile_ver, "\")\n\n", file = rprofile, sep = "")
    }
    # Final message...
    cat("\n")
    message("== The SciViews Box 2024 is now active. ==============")
    cat("- `SciViews::R()` as initial command to load the SciViews packages.\n")
    if (isTRUE(permanent)) {
      cat("- Delete '", rprofile,
        "'\n  to recover your previous R configuration.\n", sep = "")
    } else {
      cat("- Restart the R session to recover your previous R configuration.\n")
    }
    invisible(TRUE)
  }

  .install_svbox2024()
})
