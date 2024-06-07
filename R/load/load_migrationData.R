library(here)
library(dplyr)
base_url <- "https://github.com/LennartJ99/Empirical_R_Task/raw/main/"

files <- c("/migration_data2022.csv",
           "/2021.csv",
           "/2020.csv",
           "/2018.csv",
           "/2017.csv",
           "/2016.csv"
)
dest_dir <- here("input")
for (file in files) {
  download.file(paste0(base_url, file), destfile = file.path(dest_dir, file), mode = "wb")
}
migration2022<-read.csv(here("input","migration_data2022.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8", colClasses = c(Number = "character"))

migration2022<-migration2022%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-27 (seit 01.02.2020)")%>%
  mutate(Number=ifelse(nchar(Number)==4,paste0("0",Number),Number))
  


migration2021<-read.csv(here("input","2021.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8")

migration2021<-migration2021%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-27 (seit 01.02.2020)")%>%
  mutate(Number=ifelse(nchar(Number)==4,paste0("0",Number),Number))

migration2020<-read.csv(here("input","2020.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8")

migration2020<-migration2020%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-27 (seit 01.02.2020)")%>%
  mutate(Number=ifelse(nchar(Number)==4,paste0("0",Number),Number))

migration2018<-read.csv(here("input","2018.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8")

migration2018<-migration2018%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-28 (bis 31.01.2020)")%>%
  mutate(Number=ifelse(nchar(Number)==4,paste0("0",Number),Number))

migration2017<-read.csv(here("input","2017.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8")

migration2017<-migration2017%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-28 (bis 31.01.2020)")%>%
  mutate(Number=ifelse(nchar(Number)==4,paste0("0",Number),Number))


migration2016<-read.csv(here("input","2016.csv"), sep=";",skip=6, header=FALSE, encoding="UTF-8")

migration2016<-migration2016%>%
  rename(Year=V1,Number=V2,Name=V3,Origin=V4,Man=V5,Woman=V6,Total=V7)%>%
  filter(Origin=="EU-28 (bis 31.01.2020)")%>%
  mutate(Number=ifelse(nchar(Number)==4,paste0("0",Number),Number))

