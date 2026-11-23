-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### History and Time TRavel
-- MAGIC - 1.Query Delta Lake table history
-- MAGIC - 2.Query Previous versions of the data.
-- MAGIC - 3.Query data from specific time
-- MAGIC - 4.Restore data to a specific version
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###  1.Query Delta Lake table history

-- COMMAND ----------

DESCRIBE HISTORY demo.delta_lake.companies


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.Query Data from a specific version

-- COMMAND ----------

Select * from demo.delta_lake.companies
Version as of 1;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###3.Query Data from a specific timestamp
-- MAGIC

-- COMMAND ----------

SELECT * FROM demo.delta_lake.companies 
TIMESTAMP AS OF '2025-12-30T07:31:29.000+00:00'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### RESTORE Data in the table to a specific version

-- COMMAND ----------

RESTORE  TABLE demo.delta_lake.companies
VERSION AS OF 1;

-- COMMAND ----------

Select * from demo.delta_lake.companies;

-- COMMAND ----------

DESC HISTORY demo.delta_lake.companies;

-- COMMAND ----------

