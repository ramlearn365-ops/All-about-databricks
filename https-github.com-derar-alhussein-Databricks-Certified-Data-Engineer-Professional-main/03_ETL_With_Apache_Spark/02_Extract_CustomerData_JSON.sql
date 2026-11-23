-- Databricks notebook source
-- MAGIC %md 
-- MAGIC ## Extract Data From the Customers JSON File
-- MAGIC 1. Query Single File
-- MAGIC 1. Query List of Files using wildcard Characters
-- MAGIC 1. Query all the files in a Folder
-- MAGIC 1. Select File Metadata
-- MAGIC 1. Register Files in Unity Catalog using Views
-- MAGIC 1. Create Temporary View
-- MAGIC 1. Create Global Temporary View

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###1.Query Single JSON File.

-- COMMAND ----------

-- MAGIC %fs ls '/Volumes/gizmobox/landing/operational_data/customers/'

-- COMMAND ----------

SELECT * FROM json.`/Volumes/gizmobox/landing/operational_data/customers/customers_2024_10.json`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###2.Querying multiple json files in a folder

-- COMMAND ----------

SELECT * FROM Json.`/Volumes/gizmobox/landing/operational_data/customers/customers_2024_*.json`

--

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###3.Querying all files in a folder

-- COMMAND ----------

SELECT * from json.`/Volumes/gizmobox/landing/operational_data/customers/`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###4.Select File Metadata for auditing.
-- MAGIC

-- COMMAND ----------

Select 
---input_file_name() as file_path,--deperectaed from databricks runtime 13.3 LTS onwards.
_metadata.file_path as file_path,
* 
from json.`/Volumes/gizmobox/landing/operational_data/customers/customers_2024_10.json`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###5.Register Customer Files in unity catalog volumes as views in bronze schema

-- COMMAND ----------

CREATE OR REPLACE VIEW gizmobox.bronze.v_customers
AS
SELECT 
* ,_metadata.file_path as file_path
from json.`/Volumes/gizmobox/landing/operational_data/customers/`

-- COMMAND ----------

Select * from gizmobox.bronze.v_customers;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###6.Create Temperory View(in Spark)

-- COMMAND ----------

CREATE OR REPLACE TEMPORARY VIEW tv_customers
AS
SELECT 
* ,_metadata.file_path as file_path
from json.`/Volumes/gizmobox/landing/operational_data/customers/`


-- COMMAND ----------

Select * from tv_customers;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###7.Global Temporary View in SPark(NOt supported in Serverless compute)

-- COMMAND ----------

CREATE OR REPLACE GLOBAL TEMPORARY VIEW gtv_customers
AS
SELECT 
* ,_metadata.file_path as file_path
from json.`/Volumes/gizmobox/landing/operational_data/customers/`

-- COMMAND ----------

Select * from gtv_customers;

-- COMMAND ----------

