-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Higher Order Functions
-- MAGIC
-- MAGIC   > - Higher Order Functions are functions that operate on complex data types such as arrays and maps
-- MAGIC   > - They allow you to pass functions as arguments (such as lambda expressions), apply transformations and return arrays or maps 
-- MAGIC   > - They are extremely useful for manipulating arrays without exploding them. 
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Commonly used Higher Order Array Functions  
-- MAGIC   - TRANSFORM
-- MAGIC   - FILTER
-- MAGIC   - EXISTS
-- MAGIC   - AGGREGATE    

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Syntax
-- MAGIC -----------------------------------------------------------------------------
-- MAGIC `<function_name> (array_column, lambda_expression)` 
-- MAGIC
-- MAGIC _lambda_expression_: `element -> expression`

-- COMMAND ----------

CREATE OR REPLACE TEMPORARY VIEW order_items AS
SELECT * FROM 
VALUES
  (1, array('smartphone', 'laptop', 'monitor')),
  (2, array('tablet', 'headphones', 'smartwatch')),
  (3, array('keyboard', 'mouse')),
  (4,array('pendrive','otgcable','HDMI Cable'))
AS orders(order_id, items);

-- COMMAND ----------

Select * from order_items;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 1. Convert all the item names to be UPPERCASE (TRANSFORM Function)

-- COMMAND ----------

Select 
order_id,
transform(items, x-> upper(x)) as upper_items
from order_items;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 2. Filter only items that contains the string 'smart' (FILTER Function)

-- COMMAND ----------

SELECT
order_id,
FILTER(items, x-> x LIKE '%smart%')as smart_items,
FILTER(items, x-> x LIKE '%Cable%')as cable_items
FROM
order_items

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3. Check to see whether the order includes any 'monitor' (EXISTS Function)

-- COMMAND ----------

SELECT
order_id,
EXISTS(items,x->x='montor') as monitor_items
FROM
order_items

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Array with more than one object

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW Order_Items AS
SELECT * FROM VALUES
(1,array(
          named_struct('name','smartphone','price',699),
          named_struct('name','laptop','price',1199),
          named_struct('name','monitor','price',399))
),
(2, array(
        named_struct('name', 'tablet', 'price', 599),
        named_struct('name', 'headphones', 'price', 199),
        named_struct('name', 'smartwatch', 'price', 299)
    )),
  (3, array(
        named_struct('name', 'keyboard', 'price', 89),
        named_struct('name', 'mouse', 'price', 59)
    ))
    as orders(order_id,items)

    

-- COMMAND ----------

Select * from order_items;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 1. Convert all the item names to be UPPERCASE & Add 10% TAX to each item (TRANSFORM Function)

-- COMMAND ----------

SELECT
order_id,
transform(items,x->named_struct('name', upper(x.name),'price', ROUND((x.price*1.10),2))) as items_with_tax
FROM order_items

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 2. Calculate the total order amount for each of the order (AGGREGATE Function)

-- COMMAND ----------

SELECT
order_id,
aggregate(items,0,(acc,x)->acc+x.price) as total_order_price
FROM order_items

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Map Functions

-- COMMAND ----------

-- MAGIC %md
-- MAGIC A map is a collection of key-value pairs, like a dictionary  
-- MAGIC `{'laptop': 1200, 'phone': 699}`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Commonly used Higher Order Map Functions  
-- MAGIC   - TRANSFORM_VALUES
-- MAGIC   - TRANSFORM_KEYS
-- MAGIC   - MAP_FILTER

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Syntax
-- MAGIC -----------------------------------------------------------------------------
-- MAGIC `<function_name> (map_column, lambda_expression)`  
-- MAGIC _lambda expression_: `(key, value) -> expression)`

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW order_item_prices AS
SELECT * FROM VALUES
(1,map('smartphone', 699, 'laptop', 1199, 'monitor', 399)),
(2, map('tablet', 599, 'headphones', 199, 'smartwatch', 299)),
(3, map('keyboard', 89, 'mouse', 59))
AS orders(order_id, item_prices);

-- COMMAND ----------

Select * from order_item_prices

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 1. Convert all the item names to be UPPERCASE (TRANSFORM_KEYS Function)

-- COMMAND ----------

SELECT
order_id,
transform_keys(item_prices,(item,price)->upper(item)) as upper_items
FROM order_item_prices

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 2. Apply 10% TAX to item prices (TRANSFORM_VALUES Function)

-- COMMAND ----------

SELECT
order_id,
transform_values(item_prices,(item,price)-> round((price*1.1),2)) as item_prices_with_tax
FROM order_item_prices

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3. Filter only items with price above $500 (MAP_FILTER Function)

-- COMMAND ----------

SELECT
order_id,
map_filter(item_prices,(item,price)->price>500) as premium_items
FROM order_item_prices;