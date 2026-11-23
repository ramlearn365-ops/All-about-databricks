# Databricks notebook source
# MAGIC %md
# MAGIC ## Transform Customer Data
# MAGIC 1. Remove records with NULL customer_id 
# MAGIC 1. Remove exact duplicate records
# MAGIC 1. Remove duplicate records based on created_timestamp
# MAGIC 1. CAST the columns to the correct Data Type
# MAGIC 1. Write transformed data to the Silver schema

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1.Remove records with NULL customer_id 

# COMMAND ----------

df=spark.sql('SELECT * FROM gizmobox.bronze.py_customers');
display(df)

# COMMAND ----------

## Read using table api
df=spark.table('gizmobox.bronze.py_customers')
display(df)

# COMMAND ----------

## Read using table api with options
df=spark.read.table('gizmobox.bronze.py_customers')
display(df)

# COMMAND ----------

# Remove reords with Customer_isNULL
#1.usig sql
#df=df.filter('customer_id is not null')  
#2.Python Object notification
# df = df.filter(df.customer_id.isNotNull()) 
#3.using Where clause
df_filtered=df.where(df.customer_id.isNotNull())
df_filtered.display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 2.Remove exact duplicate records

# COMMAND ----------

#Using distinct
# df_distinct=df_filtered.distinct()
#using dropDuplicates()
df_distinct=df_filtered.dropDuplicates()
df_distinct.display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 3. Remove duplicate records based on created_timestamp
# MAGIC

# COMMAND ----------

from pyspark.sql.functions import max
df_max_ts=df_distinct.groupBy('customer_id').agg(max('created_timestamp').alias('max_ts'))
df_max_ts.display()


# COMMAND ----------

df_cust_distinct=(df_distinct
                  .join(df_max_ts,
                        (df_distinct.customer_id==df_max_ts.customer_id) & (df_distinct.created_timestamp==df_max_ts.max_ts),
                        'inner')
                   .select(df_distinct['*'])
)
df_cust_distinct.display()

# COMMAND ----------

df_casted_customer=(
    df_cust_distinct.select(df_cust_distinct.created_timestamp.cast('timestamp')
                            ,df_cust_distinct.customer_id
                            ,df_cust_distinct.customer_name
                            ,df_cust_distinct.date_of_birth.cast('date')
                            ,df_cust_distinct.email
                            ,df_cust_distinct.member_since.cast('date')
                            ,df_cust_distinct.telephone)
)
df_casted_customer.display();

# COMMAND ----------

# MAGIC %md
# MAGIC ### 5. Write transformed data to the Silver schema

# COMMAND ----------

df_casted_customer.writeTo('gizmobox.silver.py_customers').createOrReplace();

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from gizmobox.silver.py_customers;

# COMMAND ----------

