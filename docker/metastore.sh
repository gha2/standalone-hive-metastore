#!/bin/sh

export HADOOP_HOME=/opt/hadoop-3.2.0
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar
export JAVA_HOME=/usr/local/openjdk-8

export PGPASSWORD=hivems
psql -h postgresql -U hivems -c "\c hivems"
if [ $? -ne 0 ]
then
  export PGPASSWORD=postgres
  psql -v ON_ERROR_STOP=1  -h postgresql -U postgres <<-EOSQL
      CREATE ROLE hivems ENCRYPTED PASSWORD 'md54507e4128ef7e8b157fa8aeb399035f0' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
      CREATE DATABASE hivems;
      GRANT ALL PRIVILEGES ON DATABASE hivems TO hivems;
EOSQL
  /opt/apache-hive-metastore-3.0.0-bin/bin/schematool -initSchema -dbType postgres
fi

unset PGPASSWORD

/opt/apache-hive-metastore-3.0.0-bin/bin/start-metastore

