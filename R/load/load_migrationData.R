library(here)
library(dplyr)

migration2022<-read.csv(here("input","migration_data2022.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8")

migration2022<-migration2022%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-27 (seit 01.02.2020)")%>%
  mutate(Number = paste0("0", Number))
  
spatial_federal_districts<-spatial_federal_districts %>%
  select(ARS, geometry)
  