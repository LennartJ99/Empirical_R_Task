library(sf)
library(here)
spatial_voting_districts<-st_read(dsn = here("input","Geometrie_Wahlkreise_20DBT_VG250.shp"))
spatial_federal_districts<-st_read(dsn = here("input","VG2500_KRS.shx"))


spatial_federal_districts<-spatial_federal_districts %>%
  select(ARS, geometry)
spatial_voting_districts<-spatial_voting_districts %>%
  select(WKR_NR, geometry)