# Benchmarking file formats for cloud Storage

Repository holds test scripts for benchmark different file formats. 
CSV is relative uncompressed, sparse format but very common for data tasks, like import, export or storing. And when it comes performance of creating CSV file, reading and writing CSV files, how does it still stand against some other formats.

## Using Python 


### 1. Creating Azure Storage account and container

### 2. Creating connection to SQL Server with Python and start uploading files to Azure Account

### 3. Benchmarking different file formats for cloud storage

#### Covered formats with Python 
Benchmarking different file formats for cloud storage.
1. CSV
2. AVRO
3. Parquet
4. Pickle
5. ORC
6. TXT
7. JSON (?)
8. XML (?)


#### Python scripts for benchmarking


#### Comparing read and write times

Comparing read and write times for each file extension and see, which one performs better for given task.


## Using R  

#### Covered formats with Python 
Benchmarking different file formats for cloud storage.
1. CSV
2. Parquet
3. Feather


#### R scripts for benchmarking


## Cloning the repository
You can follow the steps below to clone the repository.
```
git clone https://github.com/tomaztk/Benchmarking-file-formats-for-cloud.git
```


## Related Blog posts

- [CSV or alternatives? Exporting data from SQL Server data to ORC, AVRO, Parquet, Feather files and store them into Azure data lake](https://tomaztsql.wordpress.com/2022/05/06/csv-or-alternatives-exporting-data-from-sql-server-data-to-orc-avro-parquet-feather-files-and-store-them-into-azure-data-lake/)
- [Comparing performances of CSV to RDS, Parquet, and Feather file formats in R](https://tomaztsql.wordpress.com/2022/05/08/comparing-performances-of-csv-to-rds-parquet-and-feather-data-types/)


