-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Understanding Delta LAke Transaction Log
-- MAGIC Understand the cloud storage ,directory structure behind delta lake tables. 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 0.Create new Schema "delta_lake" under the catalog demo for this Section
-- MAGIC

-- COMMAND ----------

SHOW CATALOGS;

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC ### ## CREATE CATALOG demo

-- COMMAND ----------

CREATE CATALOG IF NOT EXISTS demo
MANAGED LOCATION 'abfss://demo@storageacctdatabricks21.dfs.core.windows.net'

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC ### CREATE SCHEMA delta_lake

-- COMMAND ----------

CREATE SCHEMA IF NOT EXISTS demo.delta_lake
MANAGED LOCATION 'abfss://demo@storageacctdatabricks21.dfs.core.windows.net/delta_lake'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1.Create a  Delta Lake Table

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS demo.delta_lake.companies
(
  CompanyName STRING,
  Fouded_Date DATE,
  Country STRING
)

-- COMMAND ----------

DESC EXTENDED demo.delta_lake.companies;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Insert Some Data

-- COMMAND ----------

INSERT INTO demo.delta_lake.companies
VALUES ("Apple", "1976-04-01", "USA");

-- COMMAND ----------

SELECT * FROM demo.delta_lake.companies;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Insert some more data.

-- COMMAND ----------

INSERT INTO demo.delta_lake.companies 
VALUES ("Microsoft", "1975-04-04", "USA"),
       ("Google", "1998-09-04", "USA"),
       ("Amazon", "1994-07-05", "USA");

-- COMMAND ----------

