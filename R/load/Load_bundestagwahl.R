library(here)
library(dplyr)


Election<-read.csv(here("input","btw2021kreis.csv"), sep=";", header=TRUE, encoding="UTF-8",skip=9)
Election<-Election%>%
  filter(Gebietsart=="Wahlkreis")%>%
  filter(Gruppenname=="AfD")%>%
  filter(Stimme=="2")%>%
  select(c("Gebietsnummer","Anzahl","Prozent","VorpAnzahl","VorpProzent"))
###Percentages from the Datatset are in character, and we cant convert them to numeric because of the commas.
###To solve this Problem we transform the comma to a point and convert to numeric.


Election<-Election%>%
  mutate(Prozent=as.numeric(gsub(",", ".", Prozent, fixed=TRUE)))%>%
  mutate(VorpProzent=as.numeric(gsub(",", ".", VorpProzent, fixed=TRUE)))
