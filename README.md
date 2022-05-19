# Benchmarking file formats for cloud Storage

Repository holds test scripts for benchmark different file formats. 
CSV is relative uncompressed, sparse format but very common for data tasks, like import, export or storing. And when it comes performance of creating CSV file, reading and writing CSV files, how does it still stand against some other formats.

## Using Python 

#### Covered formats with Python 
Benchmarking different file formats for cloud storage.
1. CSV
2. AVRO
3. Parquet
4. Pickle
5. ORC
6. TXT

#### Python scripts for benchmark test

```python
create_df()
 
# results for write
print(timeit.Timer(WRITE_CSV_fun_timeIt).timeit(number=number_of_runs))
print(timeit.Timer(WRITE_ORC_fun_timeIt).timeit(number=number_of_runs))
print(timeit.Timer(WRITE_PARQUET_fun_timeIt).timeit(number=number_of_runs))
print(timeit.Timer(WRITE_PICKLE_fun_timeIt).timeit(number=number_of_runs))
 
CLEAN_files()
```

## Using R  

#### Covered formats with R  
1. CSV
2. Parquet
3. Feather


#### R scripts for benchmarking

```R
benchmark_write <- data.frame(summary(microbenchmark(
          "test_df.csv"     = write.csv(test_df, file = file_csv),
          "test_df_readr.csv"     = readr::write_csv(test_df, file = file_csv_readr),
          "test_df_datatable.csv"     = data.table::fwrite(test_df, file = file_csv_datatable),
          "test_df.feather" = write_feather(test_df, file_feather),
          "test_df.parquet" = write_parquet(test_df, file_parquet),
          "test_df.rds"     = save(test_df, file = file_rdata),
          "test_df.RData"   = saveRDS(test_df, file_rds), 
  times = nof_repeat)))
```

## Comparing read and write times

Comparing read and write times for each file extension and see, which one performs better for given task. 

Example in case of testing with R:

![alt text](https://tomaztsql.files.wordpress.com/2022/05/plot_zoom_png.png "Benchmark with R")


## Cloning the repository
You can follow the steps below to clone the repository.
```
git clone https://github.com/tomaztk/Benchmarking-file-formats-for-cloud.git
```

## Using Azure Blob storage for data lake

Running SQL Server on-premise and uploading data to data lake, there is a python script (Jupyter notebook) with detailed steps and script.

[Link](https://github.com/tomaztk/Benchmarking-file-formats-for-cloud/blob/main/From_SQLServer_To_AzureBlobStore.ipynb)


## Related Blog posts

- [CSV or alternatives? Exporting data from SQL Server data to ORC, AVRO, Parquet, Feather files and store them into Azure data lake](https://tomaztsql.wordpress.com/2022/05/06/csv-or-alternatives-exporting-data-from-sql-server-data-to-orc-avro-parquet-feather-files-and-store-them-into-azure-data-lake/)
- [Comparing performances of CSV to RDS, Parquet, and Feather file formats in R](https://tomaztsql.wordpress.com/2022/05/08/comparing-performances-of-csv-to-rds-parquet-and-feather-data-types/)

## Contributors and co-authors

Thanks to these wonderful R community people for upgrading and improving these benchmarks. Your contributions are highly appreciated!
<table>
  <tr>
    <td align="center"><a href="https://github.com/aguynamedryan"><img src="https://avatars.githubusercontent.com/u/117722?v=4" width="100px;" alt="Ryan Duryea"/><br /><sub><b>Ryan Duryea</b></sub></a><br /></td>
   
</tr>

</table>


