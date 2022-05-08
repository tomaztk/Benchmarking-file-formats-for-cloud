## Reading and writing to CSV, Parquet, RDS, AVRO and ORC?


library(microbenchmark)
library(rbenchmark)
library(feather)
library(data.table)
# install.packages("arrow")
library(arrow)
library(stringi)
library(sparklyr)
library(sparkavro)

setwd("/Users/tomazkastrun/Downloads/")

#file names
file_csv <- 'test_df.csv'
file_feather <- 'test_df.feather'
file_rdata <- 'test_df.RData'
file_rds <- 'test_df.rds'
file_parquet <- 'test_df.parquet'
file_avro <- 'test_df.avro'


#spark_install(version = "2.0.1")
#sc <- spark_connect(master = "local")
#df <- spark_read_avro(
#  sc,
#  "testing performance",
#  system.file("test_df.avro", package = "sparkavro"),
#  repartition = FALSE,
#  memory = FALSE,
#  overwrite = FALSE
#)
#spark_disconnect(sc)

# Create a sample file
nof_rows = 10^6 #1 mio rows

test_df <- data.frame(
                replicate(10, sample(0:10000, nof_rows, rep = TRUE)),
                replicate(10, runif(nof_rows, 0.0, 1.0)),
                replicate(10, stri_rand_strings(1000, 10))
                 )

# check data.frame
head(test_df)


##### Saving to a file on local disk
benchmark_write <- microbenchmark(
          "test_df.csv"     = write.csv(test_df, file = file_csv),
          "test_df.feather" = write_feather(test_df, file_feather),
          "test_df.parquet" = write_parquet(test_df, file_parquet),
          "test_df.rds"     = save(test_df, file = file_rdata),
          "test_df.RData"   = saveRDS(test_df, file_rds), 
  times = 5)


#spark_write_avro(test_df, path=file_avro)
  
  

info <- file.info(c('test_df.csv', 'test_df.feather', 'test_df.RData', 'test_df.rds', 'test_df.parquet'))
info$size_mb <- info$size/(1024 * 1024)
# print(subset(info, select=c("size_mb")))


benchmark_read <- microbenchmark("test_df.csv_read" = read.csv(file_csv),
                            "test_df.csv_readr" = readr::read_csv(file_csv),
                            "test_df.csv_fread" = data.table::fread(file_csv),
                            "test_df.rds"  = load(file_rdata),
                            "test_df.RData" = readRDS(file_rds),
                            "test_df.feather" = arrow::read_feather(file_feather),
                            "test_df.parquet" = read_parquet(file_parquet), times = 5)

#merge results
benchmark_write
benchmark_read
info
