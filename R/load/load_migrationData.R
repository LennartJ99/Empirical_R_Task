library(wiesbaden)
library(dotenv)

d <- retrieve_datalist(tableseries="125*", genesis=c(db="regio",user=Sys.getenv("unGenesis"), password=Sys.getenv("pwGenesis")))      
data_migration<- retrieve_data(tablename="12521-0041", genesis=c(db="regio",user=Sys.getenv("unGenesis"), password=Sys.getenv("pwGenesis")))

