-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Extract Data From the Orders JSON File
-- MAGIC 1. Query Orders File using JSON Format
-- MAGIC 1. Query Orders File using TEXT Format
-- MAGIC 1. Create Orders View in Bronze Schema

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1.Query Orders File using JSON Format

-- COMMAND ----------

SELECT * from json.`/Volumes/gizmobox/landing/operational_data/orders`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2.Query Orders File using TEXT Format

-- COMMAND ----------

SELECT *,_metadata.file_path from text.`/Volumes/gizmobox/landing/operational_data/orders`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###3.Create Orders View in Bronze Schema

-- COMMAND ----------

CREATE OR REPLACE VIEW gizmobox.bronze.v_orders
AS
SELECT *,_metadata.file_path as file_path from text.`/Volumes/gizmobox/landing/operational_data/orders`

-- COMMAND ----------

Select * from gizmobox.bronze.v_orders;

-- COMMAND ----------

