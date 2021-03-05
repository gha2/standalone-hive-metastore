
# Setup

wget https://www-us.apache.org/dist/hive/hive-standalone-metastore-3.0.0/hive-standalone-metastore-3.0.0-bin.tar.gz
tar xvzf hive-standalone-metastore-3.0.0-bin.tar.gz
mv apache-hive-metastore-3.0.0-bin/ hive-metastore-3.0.0

wget https://apache.mediamirrors.org/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz # Now, not working. Need to manually fetch old release
tar xvzf hadoop-3.2.0.tar.gz

mv *.tar.gz archives/
