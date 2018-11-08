cp /usr/lib/hive/conf/hive-site.xml /usr/lib/spark/conf
bdconfig set_property \
  --configuration_file "/usr/lib/spark/conf/hive-site.xml" \
  --name 'hive.execution.engine' --value 'mr' \
  --clobber
