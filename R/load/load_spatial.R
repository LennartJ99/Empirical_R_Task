library(sf)
library(here)
library(dplyr)
#To automate the download of the spatial data, we uploaded the corresponding files
#to our Github repository and download them from there. The original data regarding 
#the voting districts is from https://www.bundeswahlleiterin.de/bundestagswahlen/2021/wahlkreiseinteilung/downloads.html. 
#and https://www.bundeswahlleiterin.de/bundestagswahlen/2017/wahlkreiseinteilung/downloads.html (there was a voting
#district change between both elections)
#The spatial data regarding the federal data is from federal office of cartography and geodesy
#https://gdz.bkg.bund.de/index.php/default/digitale-geodaten/verwaltungsgebiete/verwaltungsgebiete-1-250-000-stand-01-01-vg250-01-01.html

#Spatial Data Voting Districts 2017
dest_dir <- here("input")

shapefile_path <- file.path(dest_dir, "Geometrie_Wahlkreise_19DBT_VG250_17.shp")
spatial_voting_districts_17 <- st_read(dsn = shapefile_path)

#Spatial Data Voting Districts 2021

shapefile_path <- file.path(dest_dir, "Geometrie_Wahlkreise_20DBT_VG250.shp")
spatial_voting_districts_21 <- st_read(dsn = shapefile_path)

#Spatial Data Federal Districts

shapefile_path <- file.path(dest_dir, "VG250_KRS.shp")
spatial_federal_districts <- st_read(dsn = shapefile_path)

spatial_federal_districts<-spatial_federal_districts %>%
  select(ARS, geometry)
spatial_voting_districts_17<-spatial_voting_districts_17 %>%
  select(WKR_NR, geometry)
spatial_voting_districts_21<-spatial_voting_districts_21 %>%
  select(WKR_NR, geometry)