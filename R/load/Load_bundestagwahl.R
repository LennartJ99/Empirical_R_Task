library(here)
url<-"https://www.bundeswahlleiterin.de/dam/jcr/af56635e-73d7-404f-8745-9dbf2e023de3/btw2021kreis.csv"
download.file(url, destfile=here("output","btw2021kreis.csv")
  
)
