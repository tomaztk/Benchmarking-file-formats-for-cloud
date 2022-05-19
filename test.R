## Reading and writing to CSV, Parquet, RDS, AVRO and ORC?

library(microbenchmark)
library(rbenchmark)
library(feather)
library(data.table)
library(fst)
library(qs)
# install.packages("arrow")
library(arrow)
library(stringi)
library(readr)
library(dplyr)
library(withr)

run_tests <- function() {
  # test parameters for creating a file
  nof_rows = 10000 #10^6 #1 mio rows
  nof_repeat <- 10


  #file names
  file_csv <- 'test_df.csv'
  file_csv_readr <- 'test_df_readr.csv'
  file_csv_datatable <- 'test_df_datatable.csv'
  file_feather <- 'test_df.feather'
  file_fst <- 'test_df.fst'
  file_qs <- 'test_df.qs'
  file_rdata <- 'test_df.RData'
  file_rds <- 'test_df.rds'
  file_parquet <- 'test_df.parquet'
  #file_avro <- 'test_df.avro'


  files <- file.info(c(
                       'test_df.csv',
                       'test_df_readr.csv',
                       'test_df_datatable.csv',
                       'test_df.feather',
                       'test_df.fst',
                       'test_df.qs',
                       'test_df.RData',
                       'test_df.rds',
                       'test_df.parquet'))



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
            "test_df.fst" = write_fst(test_df, file_fst),
            "test_df.qs" = qs::qsave(test_df, file_qs),
            "test_df.parquet" = write_parquet(test_df, file_parquet),
            "test_df.rds"     = save(test_df, file = file_rdata),
            "test_df.RData"   = saveRDS(test_df, file_rds),
    times = nof_repeat)))

  colnames(benchmark_write) <- c("names", "write_min", "write_lq", "write_mean", "write_median", "write_uq", "write_max", "write_repeat")



  files$size_mb <- files$size/(1024 * 1024)
  files$names <- rownames(files)
  files <- files[,c("names", "size_mb")]

  ##### Reading from a file on local disk and benchmark the reads
  benchmark_read <- data.frame(summary(microbenchmark(
                              "test_df.csv" = read.csv(file_csv),
                              "test_df_readr.csv" = readr::read_csv(file_csv_readr),
                              "test_df_datatable.csv" = data.table::fread(file_csv_datatable),
                              "test_df.rds"  = load(file_rdata),
                              "test_df.RData" = readRDS(file_rds),
                              "test_df.feather" = arrow::read_feather(file_feather),
                              "test_df.fst" = read_fst(file_fst),
                              "test_df.qs" = qs::qread(file_qs),
                              "test_df.parquet" = read_parquet(file_parquet), times = nof_repeat)))

  colnames(benchmark_read) <- c("names", "read_min", "read_lq", "read_mean", "read_median", "read_uq", "read_max", "read_repeat")


  #merge results and create factors
  results <- dplyr::inner_join(dplyr::inner_join(benchmark_read, files, by = "names"), benchmark_write, by = "names")
  results <- results[,c("names","size_mb","read_min", "read_max", "read_median","write_min","write_max", "write_median")]

  results$names <- as.factor(results$names)

  ###########
  ### graph
  ###########
  library(glue)
  library(ggtext)
  library(ggplot2)

  title_lab_adjusted <- glue::glue(
    "File types comparison on<br><span style = 'color:red;'>read operation</span> and <br><span style='color:darkgreen';>write operation</span>")

  ggplot(results, aes(x=names, y=size_mb)) +
       geom_bar(stat="identity", fill="lightblue") +
       geom_text(aes(label=paste0(format(round(size_mb, 2), nsmall = 2), " MiB", collapse=NULL)), vjust=-0.3, size=3.5)+
       theme(axis.text.x = element_text(angle = 45, hjust = 1.3)) +
       coord_cartesian(ylim = c(0, 5), expand = F) +
       scale_y_continuous(breaks = seq(0, 5, 1),labels = scales::label_comma(accuracy = 1)) +
      theme(panel.border = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.line = element_line(size = 0.1, linetype = "solid", colour = "grey50")) +
      ylab(label = 'Time (sec.) + File_Size') +  xlab(label = 'Files') +
    labs(title = title_lab_adjusted) +
    theme(
      plot.title = element_markdown(),
      panel.background = element_rect(color = NA, fill = 'white')) +

    geom_point (aes(y=write_median/100, group=names),
          col = "darkgreen",
          size = 2,
          stat ="identity",
          alpha=.8) +
    geom_point(aes(y=read_median/100, group=names),
             col = "red",
             size = 2,
             stat ="identity",
             alpha=.8 )
  ggsave("results.png")
}

withr::with_dir("/tmp", run_tests())

