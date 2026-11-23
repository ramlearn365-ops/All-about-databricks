-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Query Orders Data as JSON Strings
-- MAGIC 1. Extract Top Level Column Values
-- MAGIC 1. Extract Array elements
-- MAGIC 1. Extract Nested Column Values
-- MAGIC 1. CAST Column Values to a Specific Data Type

-- COMMAND ----------

SELECT * FROM gizmobox.bronze.v_orders;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Extract Top Level Object Values
-- MAGIC Top Level Object `<column_name>:<extraction_path>`

-- COMMAND ----------

SELECT
value:order_id as order_id,
value
FROM gizmobox.bronze.v_orders;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Extract Array elements
-- MAGIC To extract array elements - use the indices in brackets `<column_name>:<extraction_path>[index]`

-- COMMAND ----------

SELECT
value:order_id as order_id,
value:items[0] as item_1,
value:items[1] as item_2,
value
FROM gizmobox.bronze.v_orders;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Extract Nested Column Values
-- MAGIC To extract nested fields, use dot notation `<column_name>:<extraction_path>[index].<leaf node>` 

-- COMMAND ----------

SELECT
value:order_id as order_id,
value:items[0].item_id as item_1_item_id,
value:items[0].name as item_1_item_name,
value:items[1] as item_2,
value
FROM gizmobox.bronze.v_orders;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. CAST Column Values to a Specific Data Type

-- COMMAND ----------

SELECT
value:order_id as order_id,
value:items[0].item_id::INTEGER as item_1_item_id,
value:items[0].name as item_1_item_name,
value:items[1] as item_2,
value
FROM gizmobox.bronze.v_orders;