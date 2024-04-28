library(here)
url<-"https://www.merkur.de/assets/images/26/961/26961696-ein-wahlplakat-der-afd-am-holocaust-denkmal-in-wuerzburg-sorgte-fuer-aufregung-2G53FRmsVDec.jpg"
download.file(url,destfile=here("input", "Wahlplakat1_AFD.jpg"),  mode="wb")
url<-"https://www.main-echo.de/storage/image/7/0/4/1/4651407_original2560_1zX9HW_WbcJqS.jpg"
download.file(url,destfile=here("input", "Wahlplakat2_AFD.jpg"),  mode="wb")

