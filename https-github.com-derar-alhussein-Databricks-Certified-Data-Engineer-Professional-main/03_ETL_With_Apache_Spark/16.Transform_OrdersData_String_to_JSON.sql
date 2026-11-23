-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Transform Orders Data - String to JSON
-- MAGIC 1. Pre-process the JSON String to fix the Data Quality Issues
-- MAGIC 1. Transform JSON String to JSON Object
-- MAGIC 1. Write transformed data to the silver schema

-- COMMAND ----------

SELECT
*
FROM gizmobox.bronze.v_orders;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Pre-process the JSON String to fix the Data Quality Issues
-- MAGIC [regexp_replace function](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/regexp_replace)

-- COMMAND ----------


CREATE OR REPLACE TEMP VIEW tv_orders_fixed
AS
SELECT
value,
regexp_replace(value,'"order_date": (\\d{4}-\\d{2}-\\d{2})','"order_date": "\$1"')as fixed_value
FROM gizmobox.bronze.v_orders;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Transform JSON String to JSON Object
-- MAGIC - Function [schema_of_json](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/schema_of_json)
-- MAGIC - Function [from_json](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/from_json)

-- COMMAND ----------

Select  
schema_of_json(fixed_value) as schema,
fixed_value
from tv_orders_fixed
LIMIT 1;

-- COMMAND ----------

Select  
from_json(fixed_value,
    'STRUCT<customer_id: BIGINT, items: ARRAY<STRUCT<category: STRING, details: STRUCT<brand: STRING, color: STRING>, item_id: BIGINT, name: STRING, price: BIGINT, quantity: BIGINT>>, order_date: STRING, order_id: BIGINT, order_status: STRING, payment_method: STRING, total_amount: BIGINT, transaction_timestamp: STRING>') as json_vaue,
fixed_value
from tv_orders_fixed


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Write transformed data to the silver schema

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gizmobox.silver.orders_json
AS
Select  
from_json(fixed_value,
    'STRUCT<customer_id: BIGINT, items: ARRAY<STRUCT<category: STRING, details: STRUCT<brand: STRING, color: STRING>, item_id: BIGINT, name: STRING, price: BIGINT, quantity: BIGINT>>, order_date: STRING, order_id: BIGINT, order_status: STRING, payment_method: STRING, total_amount: BIGINT, transaction_timestamp: STRING>') as json_vaue
from tv_orders_fixed;

-- COMMAND ----------

Select * from gizmobox.silver.orders_json;

-- COMMAND ----------

