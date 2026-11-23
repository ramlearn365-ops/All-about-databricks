-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Remove unused files using VACUUM

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### VACUUM Command
-- MAGIC
-- MAGIC > Used to remove old, unused files from the Delta Lake to free up storage. Permanently deletes files that are no longer referenced in the transaction log and older than retention threshold (default 7 days)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### 1. Check the table history

-- COMMAND ----------

DESC HISTORY demo.delta_lake.optimize_stock_prices

-- COMMAND ----------

ALTER TABLE demo.delta_lake.optimize_stock_prices
SET TBLPROPERTIES ('delta.enableRetentionDurationCheck.enabled' = 'false');

-- COMMAND ----------

VACUUM demo.delta_lake.optimize_stock_prices;

-- COMMAND ----------

SET spark.databricks.delta.retentionDurationCheck.enabled = false;
VACUUM demo.delta_lake.optimize_stock_prices RETAIN 1 HOURS;

-- COMMAND ----------

Select * from demo.delta_lake.optimize_stock_prices;

-- COMMAND ----------

