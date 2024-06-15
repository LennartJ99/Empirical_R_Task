library(here)
library(dplyr)


Population<-read.csv(here("input","Population.csv"), sep=";", header=TRUE, encoding="UTF-8",skip=1)
Population<-Population%>%
  mutate(ARS=ifelse(nchar(X)==4,paste0("0",X),X))%>%
  mutate(Population2017=as.numeric(gsub(".","",sub(",.*", "", X2017),fixed=TRUE)))%>%
  mutate(Population2021=as.numeric(gsub(".","",sub(",.*", "", X2021),fixed=TRUE)))%>%
  select("ARS","Population2017","Population2021")