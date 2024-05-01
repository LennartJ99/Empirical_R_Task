library(sf)
library(here)
spatial_voting_districts<-st_read(dsn = here("input","Geometrie_Wahlkreise_20DBT_VG250.shp"))
spatial_federal_districts<-st_read(dsn = here("input","VG2500_KRS.shx"))

library(ggplot2)


ggplot() +
  geom_sf(data = spatial_voting_districts)

ggplot() +
  geom_sf(data = spatial_federal_districts)