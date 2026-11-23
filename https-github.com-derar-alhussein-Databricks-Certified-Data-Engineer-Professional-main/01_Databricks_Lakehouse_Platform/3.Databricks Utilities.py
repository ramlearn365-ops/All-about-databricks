# Databricks notebook source
# MAGIC %md
# MAGIC ## Databrciks Utitlities
# MAGIC
# MAGIC - FilesSystem Utitlities
# MAGIC - Secrets Utitlities
# MAGIC - Widget Utitlities
# MAGIC - Notebook Workflow Utitlities

# COMMAND ----------

# MAGIC %md
# MAGIC ### File System Utitlities

# COMMAND ----------

# MAGIC %fs ls /

# COMMAND ----------

display(dbutils.fs.ls('/'))

# COMMAND ----------

# MAGIC %fs ls dbfs:/databricks-datasets/

# COMMAND ----------

items=dbutils.fs.ls('dbfs:/databricks-datasets/')

# COMMAND ----------

#count folder and files using list comprehensions
folder_count=len([item for item in items if item.isDir()])
file_count=len([item for item in items if item.isFile()])

#Display Results
print(f"Total Folders: {folder_count}")
print(f"Total Files : {file_count}")

# COMMAND ----------

dbutils.fs.help()

# COMMAND ----------

dbutils.help()

# COMMAND ----------

