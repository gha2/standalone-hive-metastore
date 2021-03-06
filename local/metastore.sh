#!/bin/sh

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# To adjust localy
export JAVA_HOME=/usr/local/opt/openjdk/

export HADOOP_HOME=${MYDIR}/hadoop-3.2.0
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.*.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-*.jar

export PGPASSWORD=hivems
psql -h localhost -U hivems -c "\c hivems"
if [ $? -ne 0 ]
then
  export PGPASSWORD=postgres
  psql -v ON_ERROR_STOP=1  -h localhost -U postgres <<-EOSQL
      CREATE ROLE hivems ENCRYPTED PASSWORD 'md54507e4128ef7e8b157fa8aeb399035f0' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
      CREATE DATABASE hivems;
      GRANT ALL PRIVILEGES ON DATABASE hivems TO hivems;
EOSQL
  ${MYDIR}/hive-metastore-3.0.0/bin/schematool -initSchema -dbType postgres
fi

unset PGPASSWORD

${MYDIR}/hive-metastore-3.0.0/bin/start-metastore

