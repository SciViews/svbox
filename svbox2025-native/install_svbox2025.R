# Configure R 4.4 into a SciViews Box 2025, using a different library
# Copyright (c) 2025, Philippe Grosjean (phgrosjean@sciviews.org).

local({
  .install_svbox2025 <- function(
      allusers = as.logical(Sys.getenv("SVBOX_ALLUSERS", TRUE)),
      delete.xzfile = as.logical(Sys.getenv("SVBOX_DELETE_XZFILE", TRUE)),
      include.site.library =
        as.logical(Sys.getenv("SVBOX_INCLUDE_SITE_LIBRARY", FALSE))) {

    message("=== Installing the SciViews Box 2025...===")

    # Check that R is version 4.4.x
    r_version <- getRversion()
    if (r_version < '4.4' || r_version >= '4.5') {
      stop("R 4.4.x is required for SciViews Box 2025")
    }
    # Check that there is no other package on the search path than base ones
    loaded_pkgs <- search()
    loaded_pkgs <- loaded_pkgs[grepl("^package:", loaded_pkgs)]
    accepted_pkgs <- c(
      "package:base", "package:methods", "package:datasets", "package:utils",
      "package:grDevices", "package:graphics", "package:stats")
    if (!all(loaded_pkgs %in% accepted_pkgs)) {
      message(
        "Only base, methods, datasets, utils, grDevices, graphics or stats ",
        "packages should be loaded in the search path.\nRestart the R session ",
        "after install for a clean SciViews Box 2025 experience.")
    }

    # Do we install for all users, or just for me?
    if (is.na(allusers) && interactive()) {
      allusers <- utils::askYesNo(prompts = gettext(c("Yes", "No", "Cancel")),
        "Do you want to install the SciViews Box 2025 for all users?")
      if (is.na(allusers)) # User cancelled
        return(invisible(FALSE))
    } else if (is.na(allusers)) {# Default if not provided is FALSE
      allusers <- FALSE
    }

    # Depending on the OS and flavor, paths are different
    # TODO: deal with other architectures
    cv_alt_lib <- NA # This will contain the path to an alternate library
    if (.Platform$OS.type == "windows") {# Windows (assume 64bit Intel)
      os <- "win_x86_64"
      lib_size <- 842964600
      lib_md5 <- "73ab4878025f93722c73ccbd4db020fc"
      sv_lib <- NA
      if (isTRUE(allusers)) {# Try to install the library for all users
        sv_lib <- file.path(Sys.getenv("PROGRAMDATA"),
          "R", "sciviews-library", "4.4")
        sv_lib <- gsub("\\\\", "/", sv_lib)
        if (!dir.exists(sv_lib)) {# Try creating it
          dir.create(sv_lib, recursive = TRUE, showWarnings = FALSE)
          if (dir.exists(sv_lib)) {
            unlink(sv_lib)
            sv_alt_lib <- file.path(Sys.getenv("LOCALAPPDATA"),
              "R", "sciviews-library", "4.4")
            sv_alt_lib <- gsub("\\\\", "/", sv_alt_lib)
          } else {# If cannot create it, give up
            message(
              "Cannot create the SciViews Box 2025 library for all users.\n",
              "It will be installed only for the current user.")
            sv_lib <- NA
          }
        }
      }
      if (is.na(sv_lib)) {# Install only for the current user
        sv_lib <- file.path(Sys.getenv("LOCALAPPDATA"),
          "R", "sciviews-library", "4.4")
        sv_lib <- gsub("\\\\", "/", sv_lib)
      }
      user_lib <- file.path(Sys.getenv("LOCALAPPDATA"),
        "R", "svuser-library", "4.4")
      user_lib <- gsub("\\\\", "/", user_lib)
      rprofile <- file.path(Sys.getenv("HOME"), ".Rprofile")
      rprofile <- gsub("\\\\", "/", rprofile)

    } else if (grepl("darwin", R.version$os)) {# macOS
      if (R.version$arch == "aarch64") {# Mac Silicon
        os <- "mac_arm64"
        lib_size <- 775628796
        lib_md5 <- "ebdb403ebc7979a89957f98da60168a8"
        if (isTRUE(allusers)) {
          sv_lib <- paste0("/Library/Frameworks/R.framework/Versions/",
            "4.4-arm64/Resources/sciviews-library")
          dir.create(sv_lib, showWarnings = FALSE)
          if (!dir.exists(sv_lib)) {# If I cannot create it, use user folder
            message(
              "Cannot create the SciViews Box 2025 library for all users.\n",
              "It will be installed only for the current user.")
            sv_lib <- "~/Library/R/arm64/4.4/sciviews-library"
          } else {
            unlink(sv_lib)
            sv_alt_lib <- "~/Library/R/arm64/4.4/sciviews-library"
          }
        } else {
          sv_lib <- "~/Library/R/arm64/4.4/sciviews-library"
        }
        user_lib <- "~/Library/R/arm64/4.4/svuser-library"
        rprofile <- file.path(Sys.getenv("HOME"), ".Rprofile")
      } else {# Mac Intel
        os <- "mac_x86_64"
        lib_size <- 784864284
        lib_md5 <- "b43a845d49e16ffad34371e522fcad55"
        if (isTRUE(allusers)) {
          sv_lib <- paste0("/Library/Frameworks/R.framework/Versions/",
            "4.4-x86_64/Resources/sciviews-library")
          dir.create(sv_lib, showWarnings = FALSE)
          if (!dir.exists(sv_lib)) {# If I cannot create it, use user folder
            message(
              "Cannot create the SciViews Box 2025 library for all users.\n",
              "It will be installed only for the current user.")
            sv_lib <- "~/Library/R/x86_64/4.4/sciviews-library"
          } else {
            unlink(sv_lib)
            sv_alt_lib <- "~/Library/R/x86_64/4.4/sciviews-library"
          }
        } else {
          sv_lib <- "~/Library/R/x86_64/4.4/sciviews-library"
        }
        user_lib <- "~/Library/R/x86_64/4.4/svuser-library"
        rprofile <- file.path(Sys.getenv("HOME"), ".Rprofile")
      }
    } else {# Not Windows nor macOS, not supported for now
      stop("Only Windows and macOS are supported for now.")
    }

    # Make sure library directories exist and we have write access to them
    dir.create(dirname(sv_lib), recursive = TRUE, showWarnings = FALSE)
    dir.create(user_lib, recursive = TRUE, showWarnings = FALSE)
    if (!dir.exists(dirname(sv_lib))) {
      stop("Cannot create the SciViews Box 2025 library '", sv_lib, "'")
    } else {
      message("- SciViews Box 2025 library is '", sv_lib, "'")
    }
    if (!dir.exists(user_lib)) {
      stop("Cannot create the SciViews Box 2025 user library '", user_lib, "'")
    } else {
      message("- SciViews Box 2025 user library is '", user_lib, "'")
    }

    # Check the SciViews Box 2025 library exists or download and uncompress it
    if (!file.exists(file.path(sv_lib, "SciViews", "DESCRIPTION"))) {
      # Check disk space available (at least 4 GB)
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
      if (as.numeric(avail) < 4)
        stop("At least 4 GB of disk space are required to install the ",
          "SciViews Box 2025 library. Please, free space on the system disk.")

      # Temporary switch to the sciviews library directory
      odir <- setwd(dirname(sv_lib))
      on.exit(setwd(odir))

      # Download the SciViews Box 2025 library
      url <- paste0(
        "https://wp.sciviews.org/svbox2025/files",
        "/sciviews-library2025_", os, ".tar.xz")
      dest <- basename(url)
      if (file.exists(dest)) {# Check it is correct
        if (file.size(dest) != lib_size) {
          message("- Existing file '", dest,
            "' is corrupted (wrong size), downloading it again...")
          unlink(dest)
        } else if (tools::md5sum(dest) != lib_md5) {
          message("- Existing file '", dest,
            "' is corrupted (wrong checksum), downloading it again...")
          unlink(dest)
        }
      }

      if (!file.exists(dest)) {
        message("- Downloading the SciViews Box 2025 library, please wait...")
        otimeout <- getOption("timeout")
        on.exit(options(timeout = otimeout), add = TRUE)
        options(timeout = max(900, otimeout))
        utils::download.file(url, dest, quiet = FALSE, mode = "wb",
          cacheOK = FALSE)
      }
      # Check
      if (!file.exists(dest)) {
        stop("Cannot download the SciViews Box 2025 library from ", url)
      } else if (file.size(dest) != lib_size) {
        stop("Downloaded file '", file.path(getwd(), dest),
          "' is corrupted (wrong size). Please, relaunch the installation.")
      } else if (tools::md5sum(dest) != lib_md5) {
        stop("Downloaded file '", file.path(getwd(), dest),
          "' is corrupted (wrong checksum). Please, relaunch the installation.")
      }

      # Uncompress it
      message("- Uncompressing the SciViews Box 2025 library, be patient...")
      # Timing of this operation as a rough estimate of processing power
      # and if it takes longer than a given value, warn the user that its
      # computer is probably too slow to run the SciViews Box 2025
      # On an Intel i7-8565U, it took 7,8 minutes to uncompress the library
      # => if it takes more than 10 minutes, warn the user
      timing <- try(system.time(utils::untar(dest))["elapsed"], silent = TRUE)
      if (inherits(timing, "try-error")) {
        stop("Error when uncompressing the SciViews Box 2025 library: ", timing)
      }
      message("...done in ", timing, " seconds.")
      if (timing > 600) {
        warning("Your computer is probably too slow to run ",
          "the SciViews Box 2025 comfortably.")
      }
      # Check...
      if (!file.exists(file.path(sv_lib, "SciViews", "DESCRIPTION"))) {
        stop("Error when uncompressing the SciViews Box 2025 library from ",
          dest)
      }
      # Delete the compressed file
      if (isTRUE(delete.xzfile))
        unlink(dest)

      # If the library is installed for all users and there is also a user lib
      # (in sv_alt_lib), optionally propose to delete it
      if (!is.na(sv_alt_lib) && interactive() &&
          file.exists(file.path(sv_alt_lib, "SciViews", "DESCRIPTION"))) {
        cat("You have two different SciViews Box 2025 libraries:\n",
          "one for all users, and one for you only.\n", sep = "")
        delete_alt <- utils::askYesNo(
          prompts = gettext(c("Yes", "No", "Cancel")),
          "Do you want to delete the second (useless) one?")
        if (isTRUE(delete_alt)) {
          unlink(sv_alt_lib, recursive = TRUE)
          message("- User SciViews Box 2025 library deleted.")
        }
      }
    }

    # Switch .libPaths()
    message("- Switching to the SciViews Box 2025 library... see .libPaths()")
    old_libPaths <- .libPaths()
    if (isTRUE(include.site.library)) {
      .libPaths(c(user_lib, sv_lib, .Library))
    } else {
      .libPaths(c(user_lib, sv_lib, .Library.site, .Library))
    }

    # Change repos
    message("- Switching packages repositories to SciViews and ",
      "CRAN on 2025-04-10 (repos option)")
    orepos <- getOption("repos")
    options(repos = c(
      SciViews = "https://wp.sciviews.org/svbox2025/sciviews.r-universe.dev",
      CRAN     = "https://packagemanager.posit.co/cran/2025-04-10"))

    # Write the config in .Rprofile, .Rprofile_x.y_sciviews and
    # .Rprofile_x.y_classic files. In .Rprofile, we put only code to run either
    # .Rprofile_x.y_sciviews (by default), or .Rprofile_x.y._classic if the
    # environment variable 'R_MODE' is set to "classic". In this case, the user
    # recovers its R environement as it was before installing the SciViews Box
    # 2025 without touching to it.
    rprofile <- file.path(Sys.getenv("HOME"), ".Rprofile")
    rprofile <- gsub("\\\\", "/", rprofile)
    version_x.y <- sub('^([0-9]+\\.[0-9]+)\\..+$', '\\1', getRversion())
    rprofile_x.y_sciviews <- paste0(rprofile, "_", version_x.y, "_sciviews")
    rprofile_x.y_classic <- paste0(rprofile, "_", version_x.y, "_classic")

    # If there is already a rprofile file, back it up either into
    # rprofile_x.y_classic if it does not exists, or into rprofile.bak otherwise
    if (file.exists(rprofile)) {
      if (file.exists(rprofile_x.y_classic)) {
      rprofile_bak <- paste0(rprofile, ".bak")
      message("- Backing up your current .Rprofile file to '",
        rprofile_bak, "'")
      file.copy(rprofile, rprofile_bak, overwrite = TRUE)
      } else {# Place old .Rprofile code in rprofile_x.y._classic
        message("- Backing up your current .Rprofile file to '",
          rprofile_x.y_classic, "'")
        cat(
          "# Your classic R configuration\n",
          "# You can edit this file to restore your classic R environment\n",
          "# when you set the environment variable R_MODE to 'classic'\n",
          "# in your operating system (e.g. in .Renviron file)\n",
          "# Your code here under...\n", file = rprofile_x.y_classic, sep = "")
        file.append(rprofile_x.y_classic, rprofile)
        unlink(rprofile)
      } else {# Create an empty rptofile_x.y_classic file with instructions
        cat(
          "# Your classic R configuration\n",
          "# You can edit this file to restore your classic R environment\n",
          "# when you set the environment variable R_MODE to 'classic'\n",
          "# in your operating system (e.g. in .Renviron file)\n",
          "# Your code here under...\n", file = rprofile_x.y_classic, sep = "")
      }
    }
    message("- Writing the SciViews Box 2025 configuration to '", rprofile, "'")
    cat(
      "# Mode-specific code, do not edit!\n",
      "# Edit the .Rprofile_<x.y>_<mode> file, where <x.y> is the R version\n",
      "# (e.g. 4.4) and <mode> is either 'sciviews' (default) or 'classic'\n",
      ".rprofile_file <- paste0('", rprofile, "', '_',\n",
      "  sub('^([0-9]+\\\\.[0-9]+)\\\\..+$', '\\\\1', getRversion()),\n",
      "  '_', Sys.getenv('R_MODE', unset = 'sciviews'))\n",
      "if (file.exists(.rprofile_file))\n",
      "  source(.rprofile_file)\n", file = rprofile, sep = "")

    if (!file.exists(rprofile_x.y_sciviews)) {# Create it
      cat(
        "# SciViews Box 2025 configuration\n",
        "# .libPaths() and options(repos = ...) should not be changed\n",
        "# but you can add your own code below\n",
        "local({\n",
        "  sv_lib <- \"", sv_lib, "\"\n",
        "  user_lib <- \"", user_lib, "\"\n",
        if (isTRUE(include.site.library)) {
          "  .libPaths(c(user_lib, sv_lib, .Library.site, .Library))\n"
        } else {
          "  .libPaths(c(user_lib, sv_lib, .Library))\n"
        },
        "  options(repos = c(\n",
        "    SciViews = ",
        "'https://wp.sciviews.org/svbox2025/sciviews.r-universe.dev',\n",
        "    CRAN     = 'https://packagemanager.posit.co/cran/2025-04-10'))\n",
        "})\n# Your code here...\n", file = rprofile_x.y_sciviews, sep = "")
    }

    # Final message...
    cat("\n")
    message("=== The SciViews Box 2025 is now active. ===")
    cat("- Type `SciViews::R()` as initial command to load the SciViews packages.\n")
    invisible(TRUE)
  }

  .install_svbox2025()
})
