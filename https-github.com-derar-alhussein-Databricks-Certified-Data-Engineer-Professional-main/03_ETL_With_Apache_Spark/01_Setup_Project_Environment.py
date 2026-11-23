# Databricks notebook source
# MAGIC %md
# MAGIC ## Set-up the project environment for GizmoBox Data Lakehouse

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1.Access the container gizmobox

# COMMAND ----------

# MAGIC %fs ls 'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing/operational_data/orders'

# COMMAND ----------

# MAGIC %md
# MAGIC ###2.CREATE External Location for gizmobox container

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE EXTERNAL LOCATION IF NOT EXISTS storageacct_databricks21_gizmobox
# MAGIC URL 'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net'
# MAGIC WITH (STORAGE CREDENTIAL storagecred_ext_adlsgen2)
# MAGIC COMMENT 'External location for gizmobox data lakehouse'

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3.Create the Catalog gizmobox

# COMMAND ----------

# MAGIC %sql
# MAGIC SHOW CATALOGS;

# COMMAND ----------

# MAGIC %sql
# MAGIC
# MAGIC CREATE CATALOG IF NOT EXISTS gizmobox
# MAGIC MANAGED LOCATION 'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net'
# MAGIC COMMENT 'This is the catalog for gizmobox data lakehouse';

# COMMAND ----------

# MAGIC %md
# MAGIC ###4.Create Schemas
# MAGIC - Landing
# MAGIC - Bronze
# MAGIC - Silver
# MAGIC - Gold
# MAGIC

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT current_catalog();

# COMMAND ----------

# MAGIC %sql
# MAGIC USE CATALOG gizmobox;
# MAGIC
# MAGIC CREATE SCHEMA IF NOT EXISTS landing
# MAGIC MANAGED LOCATION  'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing';
# MAGIC
# MAGIC CREATE SCHEMA IF NOT EXISTS bronze
# MAGIC MANAGED LOCATION  'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/bronze';
# MAGIC
# MAGIC CREATE SCHEMA IF NOT EXISTS silver
# MAGIC MANAGED LOCATION  'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/silver';
# MAGIC
# MAGIC CREATE SCHEMA IF NOT EXISTS gold
# MAGIC MANAGED LOCATION  'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/gold';

# COMMAND ----------

# MAGIC %sql
# MAGIC SHOW SCHEMAS;

# COMMAND ----------

# MAGIC %md
# MAGIC ###5.CREATE EXTERNAL VOLUME

# COMMAND ----------

# MAGIC %sql
# MAGIC USE CATALOG gizmobox;
# MAGIC USE SCHEMA landing;
# MAGIC
# MAGIC CREATE EXTERNAL VOLUME IF NOT EXISTS operational_data
# MAGIC LOCATION 'abfss://gizmobox@storageacctdatabricks21.dfs.core.windows.net/landing/operational_data/'

# COMMAND ----------

# MAGIC
# MAGIC %fs ls '/Volumes/gizmobox/landing/operational_data/customers'

# COMMAND ----------

