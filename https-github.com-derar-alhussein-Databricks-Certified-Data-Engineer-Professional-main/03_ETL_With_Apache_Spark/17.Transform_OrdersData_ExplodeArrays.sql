-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Transform Orders Data - Explode Arrays
-- MAGIC 1. Access elements from the JSON object
-- MAGIC 1. Deduplicate Array Elements
-- MAGIC 1. Explode Arrays
-- MAGIC 1. Write the Transformed Data to Silver Schema

-- COMMAND ----------

Select * from gizmobox.silver.orders_json;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Access elements from the JSON object
-- MAGIC `<column_name.object>`

-- COMMAND ----------

Select 
json_vaue.customer_id,
json_vaue.order_date,
json_vaue.order_id,
json_vaue.order_status,
json_vaue.payment_method,
json_vaue.total_amount,
json_vaue.total_amount,
json_vaue.items
from gizmobox.silver.orders_json;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Deduplicate Array Elements
-- MAGIC Function [array_distinct](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/array_distinct)

-- COMMAND ----------

Select 
json_vaue.customer_id,
json_vaue.order_date,
json_vaue.order_id,
json_vaue.order_status,
json_vaue.payment_method,
json_vaue.total_amount,
json_vaue.total_amount,
array_distinct(json_vaue.items) as items
from gizmobox.silver.orders_json;

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC ### 3. Explode Arrays
-- MAGIC Function [explode](https://learn.microsoft.com/en-us/azure/databricks/sql/language-manual/functions/explode)

-- COMMAND ----------

Select 
json_vaue.order_id,
json_vaue.order_date,
json_vaue.order_status,
json_vaue.payment_method,
json_vaue.total_amount,
json_vaue.customer_id,
json_vaue.transaction_timestamp,
explode(array_distinct(json_vaue.items)) as item
from gizmobox.silver.orders_json;

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW tv_orders_exploded
AS
Select 
json_vaue.order_id,
json_vaue.order_date,
json_vaue.order_status,
json_vaue.payment_method,
json_vaue.total_amount,
json_vaue.customer_id,
json_vaue.transaction_timestamp,
explode(array_distinct(json_vaue.items)) as item
from gizmobox.silver.orders_json;

-- COMMAND ----------

Select 
order_id,
order_date,
order_status,
payment_method,
total_amount,
customer_id,
transaction_timestamp,
item.item_id,
item.name,
item.price,
item.quantity,
item.category,
item.details.brand,
item.details.color
from tv_orders_exploded;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. Write the Transformed Data to Silver Schema

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS gizmobox.silver.orders
AS
Select 
order_id,
order_date,
order_status,
payment_method,
total_amount,
customer_id,
transaction_timestamp,
item.item_id,
item.name,
item.price,
item.quantity,
item.category,
item.details.brand,
item.details.color
from tv_orders_exploded;

-- COMMAND ----------

Select transaction_timestamp from gizmobox.silver.orders
order by order_id
;

-- COMMAND ----------

