from pyspark import pipelines as dp

customer_rules={"rule1":" customer_id IS NOT NULL"}

@dp.table(name='customers')
@dp.except_all(customer_rules)
def customers():
  spark.readStream.table('gizmobox.bronze.py_customers')
  return df;