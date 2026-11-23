-- Databricks notebook source
Select 

customer_id,
items,
order_id,
-- items.item_id,
-- items.name,
-- items.category,
-- items.price,
-- items.quantity,
order_status,
order_timestamp,
payment_method
from circuitbox.lakehouse.bronze_orders;

-- COMMAND ----------

SELECT 
  order_id,
  customer_id,
  order_timestamp,
  order_status,
  payment_method,
  item.item_id,
  item.name,
  item.category,
  item.price,
  item.quantity
FROM 
  (SELECT 
  order_id,
  customer_id,
  order_timestamp,
  order_status,
  payment_method,
  explode(items) AS item
  FROM circuitbox.lakehouse.bronze_orders
);

-- COMMAND ----------

Select * from circuitbox.lakehouse.silver_orders;

-- COMMAND ----------

