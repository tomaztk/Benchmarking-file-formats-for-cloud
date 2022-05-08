## Reading and writing to CSV, Parquet, RDS, AVRO and ORC?


library(microbenchmark)
library(rbenchmark)
library(feather)
library(data.table)
# install.packages("arrow")
library(arrow)
library(stringi)

setwd("/Users/tomazkastrun/Downloads/")

#file names
file_csv <- 'test_df.csv'
file_csv_readr <- 'test_df_readr.csv'
file_csv_datatable <- 'test_df_datatable.csv'
file_feather <- 'test_df.feather'
file_rdata <- 'test_df.RData'
file_rds <- 'test_df.rds'
file_parquet <- 'test_df.parquet'
file_avro <- 'test_df.avro'


files <- file.info(c('test_df.csv','test_df_readr.csv','test_df_datatable.csv', 'test_df.feather', 'test_df.RData', 'test_df.rds', 'test_df.parquet'))

# Create a sample file
nof_rows = 1000 #10^6 #1 mio rows
nof_repeat <- 10

test_df <- data.frame(
                replicate(10, sample(0:10000, nof_rows, rep = TRUE)),
                replicate(10, runif(nof_rows, 0.0, 1.0)),
                replicate(10, stri_rand_strings(1000, 10))
                 )

# check data.frame
head(test_df)


##### Saving to a file on local disk and benchmark the writes
benchmark_write <- data.frame(summary(microbenchmark(
          "test_df.csv"     = write.csv(test_df, file = file_csv),
          "test_df_readr.csv"     = readr::write_csv(test_df, file = file_csv_readr),
          "test_df_datatable.csv"     = data.table::fwrite(test_df, file = file_csv_datatable),
          "test_df.feather" = write_feather(test_df, file_feather),
          "test_df.parquet" = write_parquet(test_df, file_parquet),
          "test_df.rds"     = save(test_df, file = file_rdata),
          "test_df.RData"   = saveRDS(test_df, file_rds), 
  times = nof_repeat)))

colnames(benchmark_write) <- c("names", "write_min", "write_lq", "write_mean", "write_median", "write_uq", "write_max", "write_repeat")


  
files$size_mb <- files$size/(1024 * 1024)
files$names <- rownames(files)

##### Reading from a file on local disk and benchmark the reads
benchmark_read <- data.frame(summary(microbenchmark(
                            "test_df.csv" = read.csv(file_csv),
                            "test_df_readr.csv" = readr::read_csv(file_csv_readr),
                            "test_df_datatable.csv" = data.table::fread(file_csv_datatable),
                            "test_df.rds"  = load(file_rdata),
                            "test_df.RData" = readRDS(file_rds),
                            "test_df.feather" = arrow::read_feather(file_feather),
                            "test_df.parquet" = read_parquet(file_parquet), times = nof_repeat)))

colnames(benchmark_read) <- c("names", "read_min", "read_lq", "read_mean", "read_median", "read_uq", "read_max", "read_repeat")


#merge results
benchmark_read
benchmark_write
files
results <- inner_join(inner_join(benchmark_read, files, by = "names"), benchmark_write, by = "names")

