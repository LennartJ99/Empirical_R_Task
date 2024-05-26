library(here)
url<-"https://www.bundeswahlleiterin.de/dam/jcr/0d1ea773-f3ca-40ea-b8ff-b031712707e1/btw17_kerg2.csv"
download.file(url, destfile=here("input","btw2021kreis.csv"))

Election2021<-read.csv(here("input","btw2021kreis.csv"), sep=";", header=TRUE, encoding="UTF-8",skip=9)

url<-"https://www.bundeswahlleiterin.de/dam/jcr/860495c9-83fb-4068-8a99-c1c985ffffd2/w-btw21_kerg2.csv"
download.file(url, destfile=here("input","btw17kreis.csv"))

Election2017<-read.csv(here("input","btw17kreis.csv"), sep=";", header=TRUE, encoding="UTF-8",skip=9)

