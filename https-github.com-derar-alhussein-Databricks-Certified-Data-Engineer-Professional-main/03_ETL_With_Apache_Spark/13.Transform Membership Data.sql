-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Transform Memberships Data
-- MAGIC 1. Extract customer_id from the file path 
-- MAGIC 1. Write transformed data to the Silver schema  

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Extract customer_id from the file path
-- MAGIC > [Documentation for regexp_extract Function](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/regexp_extract)  
-- MAGIC > [Documentation for Regex Pattern](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html)
-- MAGIC

-- COMMAND ----------

SELECT 
regexp_extract(path, '.*/([0-9]+)\\.png$', 1) AS customer_id,
content as membership_card
from gizmobox.bronze.v_memberships;

-- COMMAND ----------

-- MAGIC
-- MAGIC %md
-- MAGIC ### 2. Write transformed data to the Silver schema 
-- MAGIC

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gizmobox.silver.memberships
AS
SELECT 
regexp_extract(path, '.*/([0-9]+)\\.png$', 1) AS customer_id,
content as membership_card
from gizmobox.bronze.v_memberships; 

-- COMMAND ----------

DESC EXTENDED gizmobox.silver.memberships;

-- COMMAND ----------

SELECT * FROM gizmobox.silver.memberships;

-- COMMAND ----------

  