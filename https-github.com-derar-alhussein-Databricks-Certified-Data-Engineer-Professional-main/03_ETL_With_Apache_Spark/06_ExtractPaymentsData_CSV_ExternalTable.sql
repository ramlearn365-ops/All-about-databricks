-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Extract Data From the Payments Files
-- MAGIC 1. List the files from Payment folder
-- MAGIC 1. Create External Table
-- MAGIC 1. Demonstrate the effect of Adding/ Updating / Deleting files. 
-- MAGIC 1. Demonstrate the effect of Dropping the Table

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1.List the files from Payment folder

-- COMMAND ----------

-- MAGIC %fs ls 'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing/external_data/payments'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.Create External Table

-- COMMAND ----------

DROP TABLE IF EXISTS gizmobox.bronze.payments;
CREATE TABLE IF NOT EXISTS gizmobox.bronze.payments
(payment_id INTEGER,order_id INTEGER,payment_timestamp TIMESTAMP,payment_status INTEGER,payment_method STRING)
USING CSV
OPTIONS(header='True',delimiter=',',inferSchema='True')
LOCATION 'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing/external_data/payments'

-- COMMAND ----------

Select * from gizmobox.bronze.payments;

-- COMMAND ----------

DESCRIBE EXTENDED gizmobox.bronze.payments

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###  3.Demonstrate the effect of Adding/ Updating / Deleting files. 

-- COMMAND ----------

Select * from gizmobox.bronze.payments;

-- COMMAND ----------

REFRESH TABLE  gizmobox.bronze.payments;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4.Demonstrate the effect of Dropping the Table

-- COMMAND ----------

