-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Set-up the project environment for CircuitBox Data Lakehouse
-- MAGIC 1. Create external location - dea_course_ext_dl_circuitbox
-- MAGIC 1. Create Catalog - circuitbox
-- MAGIC 1. Create Schemas
-- MAGIC     - landing
-- MAGIC     - lakehouse
-- MAGIC 1. Create Volume - operational_data

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Create External Location
-- MAGIC **External Location Name:** storageacct_databricks21_circuitbox
-- MAGIC
-- MAGIC _ADLS Path:_ [abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/](abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/)  
-- MAGIC
-- MAGIC _Storage Credential:_ storagecred_ext_adlsgen2

-- COMMAND ----------

CREATE EXTERNAL LOCATION storageacct_databricks21_circuitbox
URL 'abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/'
WITH(STORAGE CREDENTIAL storagecred_ext_adlsgen2 )
COMMENT 'External Location for the circuitbox data lakehouse';

-- COMMAND ----------

-- MAGIC %fs ls 'abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Create catalog 
-- MAGIC **Catalog Name:** circuitbox  
-- MAGIC _Managed Location:_ [abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/](abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/)

-- COMMAND ----------

CREATE CATALOG IF NOT EXISTS circuitbox
MANAGED LOCATION 'abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/'
COMMENT 'Catalog for the circuitbox data lakehouse';

-- COMMAND ----------

SHOW CATALOGS;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Create Schemas
-- MAGIC 1. **Schema Name:** landing  
-- MAGIC    _Managed Location:_ [abfss://abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/landing](abfss://abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/landing)
-- MAGIC 1. **Schema Name:** lakehouse  
-- MAGIC    _Managed Location:_ [abfss://abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/lakehouse](abfss://abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/lakehouse)

-- COMMAND ----------

USE CATALOG circuitbox;

DROP SCHEMA IF EXISTS landing;
DROP SCHEMA IF EXISTS lakehouse;

CREATE SCHEMA IF NOT EXISTS landing
MANAGED LOCATION 'abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/landing'
COMMENT 'Schema for the circuitbox data lakehouse';

CREATE SCHEMA IF NOT EXISTS lakehouse
MANAGED LOCATION 'abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/lakehouse'
COMMENT 'Schema for the circuitbox data lakehouse';


-- COMMAND ----------

SHOW SCHEMAS;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. Create Volume
-- MAGIC **Volume Name:** operational_data  
-- MAGIC _ADLS Path:_ [abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/landing/operational_data/](abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/landing/operational_data/)

-- COMMAND ----------

DROP VOLUME IF EXISTS circuitbox.landing.operational_data;

-- COMMAND ----------


CREATE EXTERNAL VOLUME IF NOT EXISTS circuitbox.landing.operational_data
      LOCATION 'abfss://circuitbox@storageacctdatabricks21.dfs.core.windows.net/landing/operational_data';

-- COMMAND ----------

-- MAGIC %fs ls /Volumes/circuitbox/landing/operational_data

-- COMMAND ----------

