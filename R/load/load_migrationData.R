library(here)
library(dplyr)
url<-"https://github.com/LennartJ99/Empirical_R_Task/raw/ac29cfd8338f7b77a77e3aaed2d91290784c1b0e/migration_data2022.csv"
download.file(url, destfile=here("input","migration_data2022.csv"))
migration2022<-read.csv(here("input","migration_data2022.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8")

migration2022<-migration2022%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-27 (seit 01.02.2020)")%>%
  mutate(Number = paste0("0", Number))
  
