###This is the master script to run all the other scripts.
library(here)

source(here("R/load", "Health_Data.R"))
source(here("R/load", "load_migrationData.R"))
source(here("R/load", "load_bundestagwahl.R"))
source(here("R/load", "load_Unemployment+Income.R"))
source(here("R/load", "load_Spatial.R"))
source(here("R/load", "Population.R"))
source(here("R/wrangle", "Combined_Data.R"))