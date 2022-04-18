from azure.storage.blob import PublicAccess
from azure.storage.blob import BlobServiceClient
import os

connection_string="xxxxxx"
SAS_token= "xxxx"
BLOB_Service_SAS_token="xxxx"

 
from azure.storage.blob import BlobServiceClient
 

blob_service_client = BlobServiceClient(
    account_url="https://xxxxx.blob.core.windows.net/",
    credential=SAS_token
)


from azure.storage.blob import BlobClient

blob = BlobClient.from_connection_string(conn_str=connection_string, container_name="xxxx", blob_name="nodes.html")

with open("./nodes.html", "rb") as data:
    blob.upload_blob(data)

#upload CSV
from azure.storage.blob import BlobClient

df.to_csv('csvSample.csv')

blob = BlobClient.from_connection_string(conn_str=connection_string, container_name="xxxx", blob_name="csvSample.csv")

with open("./csvSample.csv", "rb") as data:
    blob.upload_blob(data)
