# Custom Functions
installpak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  }
}

# Load Packages
## Pacotes não dispníveis no CRAN - Instalação
# NonCRANPackages_b <- c("mitchelloharawild/fable.prophet", "tidyverts/fasster")
# remotes::install_github(NonCRANPackages_b)
# rm(NonCRANPackages_b)

## Pacores
RequiredPackages <- c( # Pacotes que uso, mas não quero carregar, chamo funções de maneira declarada
  "timeSeries" # Usado para criar o calendario (filho do fbasics da família Rmerics)
  , "data.table" # Uso o fread para importar e fundir as bases
  , "tictoc" # Controla o tempo
  , "remotes" # Instalação dos pacotes do Github
  , "future.apply"
) # Required for Prophet

LoadedPackages <- c(
  "tidyverse" # Life
  , "skimr",
  "future" # Parallel Processing
  
  
  # Calendar functions
  , "lubridate" # Dealing with time (ymd and others)
  , "timetk" # Exploratory
  
  # Modeling
  , "prophet"
  
  # Tidyverts
  , "tsibble",
  "fable",
  "feasts",
  "fabletools"
  
  # RMD
  , "knitr",
  "rmdformats"
)

NonCRANPackages <- c(
  "fable.prophet",
  "fasster"
)

installpak(c(RequiredPackages, LoadedPackages))
sapply(c(LoadedPackages, NonCRANPackages), require, character.only = TRUE)

# Global RMarkdown options
options(max.print = "75")
opts_chunk$set(
  echo = FALSE,
  cache = TRUE,
  prompt = FALSE,
  tidy = TRUE,
  comment = NA,
  message = FALSE,
  warning = FALSE
)
knitr::opts_knit$set(width = 75)
knitr::opts_knit$set(root.dir = rprojroot::find_rstudio_root_file())

# Environment Options
Sys.setenv("LANGUAGE" = "EN")
Sys.setlocale("LC_ALL", "en_US.UTF-8")

rm(LoadedPackages, NonCRANPackages, RequiredPackages, installpak)