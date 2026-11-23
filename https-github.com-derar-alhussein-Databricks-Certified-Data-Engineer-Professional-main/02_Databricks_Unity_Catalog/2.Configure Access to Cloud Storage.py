# Databricks notebook source
# MAGIC %md
# MAGIC ### Configure Access to Cloud Storage via Unity Catalog

# COMMAND ----------

# MAGIC %md
# MAGIC #### Access Cloud Storage

# COMMAND ----------

# MAGIC %fs ls 'abfss://demo@storageacctdatabricks21.dfs.core.windows.net'

# COMMAND ----------

# MAGIC %md
# MAGIC ### CREATE EXTERNAL LOCATION
# MAGIC creating external location for demo container in adls gen2 storage account

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE EXTERNAL LOCATION IF NOT EXISTS storageacct_databricks21_demo
# MAGIC URL 'abfss://demo@storageacctdatabricks21.dfs.core.windows.net'
# MAGIC WITH (STORAGE CREDENTIAL storagecred_ext_adlsgen2)
# MAGIC COMMENT 'External location for demo purposes'
# MAGIC

# COMMAND ----------

