library(here)
library(dplyr)
url<-"https://www.bundeswahlleiterin.de/dam/jcr/860495c9-83fb-4068-8a99-c1c985ffffd2/w-btw21_kerg2.csv"
download.file(url, destfile=here("input","btw2021kreis.csv"))

Election<-read.csv(here("input","btw2021kreis.csv"), sep=";", header=TRUE, encoding="UTF-8",skip=9)
Election<-Election%>%
  filter(Gebietsart=="Wahlkreis")%>%
  filter(Gruppenname=="AfD")%>%
  filter(Stimme=="2")%>%
  select(c("Gebietsnummer","Anzahl","Prozent","VorpAnzahl","VorpProzent"))
###Percentages from the Datatset are in character, and i cant convert them to numeric because of the commas.
###To solve this Problem we transform the comma to a point and convert to numeric.


# Apply the function to each element of the vector
Election<-Election%>%
  mutate(Prozent=as.numeric(sub(",", ".", Prozent, fixed=TRUE)))%>%
  mutate(VorpProzent=as.numeric(sub(",", ".", VorpProzent, fixed=TRUE)))
