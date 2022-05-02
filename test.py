import timeit
import time
import numpy as np
import pandas as pd

import feather
import pickle
import pyarrow as pa
import pyarrow.orc as orc 
from fastavro import writer, reader, parse_schema

number_of_runs = 3


def Create_df():
    np.random.seed = 2908
    df_size = 1000_000
    
    df = pd.DataFrame({
        'a': np.random.rand(df_size),
        'b': np.random.rand(df_size),
        'c': np.random.rand(df_size),
        'd': np.random.rand(df_size),
        'e': np.random.rand(df_size)
    })


def WRITE_CSV_fun_timeIt():
    print('Creating CSV File start')
    df.to_csv('10M.csv')
    print('Creating CSV File  end')
    

def WRITE_ORC_fun_timeIt():
    print('Creating ORC File start')
    table = pa.Table.from_pandas(df, preserve_index=False)
    orc.write_table(table, '10M.orc')
    print('Creating ORC File  end')

def WRITE_PARQUET_fun_timeIt():
    print('Creating PARQUET File start')
    df.to_parquet('10M.parquet')
    print('Creating PARQUET File  end')

def WRITE_PICKLE_fun_timeIt():
    print('Creating PICKLE File start')
    with open('10M.pkl', 'wb') as f:
        pickle.dump(df, f)
    print('Creating PICKLE File  end')


def CLEAN_files():
    import os
    file_path_o = '10M.orc'
    os.remove(file_path_o)
    file_path_p = '10M.parquet'
    os.remove(file_path_p)
    file_path_pk = '10M.pkl'
    os.remove(file_path_pk)






