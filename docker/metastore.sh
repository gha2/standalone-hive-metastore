#!/bin/sh

if [ -z "${POSTGRES_PASSWORD}" ]; then echo "POSTGRES_PASSWORD env variable must be defined!"; exit 1; fi
if [ -z "${HIVEMS_PASSWORD}" ]; then echo "HIVEMS_PASSWORD env variable must be defined!"; exit 1; fi
if [ -z "${HIVEMS_ENCRYPTED_PASSWORD}" ]; then echo "HIVEMS_ENCRYPTED_PASSWORD env variable must be defined!"; exit 1; fi
if [ -z "${POSTGRES_HOST}" ]; then echo "POSTGRES_HOST env variable must be defined!"; exit 1; fi
if [ -z "${POSTGRES_PORT}" ]; then echo "POSTGRES_PORT env variable must be defined!"; exit 1; fi

if [ -z "${S3_ENDPOINT}" ]; then echo "S3_ENDPOINT env variable must be defined!"; exit 1; fi
if [ -z "${S3_ACCESS_KEY}" ]; then echo "S3_ACCESS_KEY env variable must be defined!"; exit 1; fi
if [ -z "${S3_SECRET_KEY}" ]; then echo "S3_SECRET_KEY env variable must be defined!"; exit 1; fi



if [ -z "${JAVA_HOME}" ]
then
  export JAVA_HOME=/usr/local/openjdk-8
fi
if [ -z "${BASEDIR}" ]
then
  export BASEDIR=/opt
fi

export HADOOP_HOME=${BASEDIR}/hadoop-3.2.0
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar

cat >${BASEDIR}/apache-hive-metastore-3.0.0-bin/conf/metastore-site.xml <<-EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>metastore.thrift.uris</name>
    <value>thrift://localhost:9083</value>
    <description>Thrift URI for the remote metastore. Used by metastore client to connect to remote metastore.</description>
  </property>
  <property>
    <name>metastore.task.threads.always</name>
    <value>org.apache.hadoop.hive.metastore.events.EventCleanerTask,org.apache.hadoop.hive.metastore.MaterializationsCacheCleanerTask</value>
  </property>
  <property>
    <name>metastore.expression.proxy</name>
    <value>org.apache.hadoop.hive.metastore.DefaultPartitionExpressionProxy</value>
  </property>
  <property>
    <name>javax.jdo.option.Multithreaded</name>
    <value>true</value>
    <description>Set this to true if multiple threads access metastore through JDO concurrently.</description>
  </property>
  <property>
    <name>javax.jdo.PersistenceManagerFactoryClass</name>
    <value>org.datanucleus.api.jdo.JDOPersistenceManagerFactory</value>
    <description>class implementing the jdo persistence</description>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.postgresql.Driver</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/hivems</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>hivems</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>${HIVEMS_PASSWORD}</value>
  </property>

  <property>
    <name>fs.s3a.access.key</name>
    <value>${S3_ACCESS_KEY}</value>
  </property>
  <property>
    <name>fs.s3a.secret.key</name>
    <value>${S3_SECRET_KEY}</value>
  </property>
  <property>
    <name>fs.s3a.endpoint</name>
    <value>${S3_ENDPOINT}</value>
  </property>
  <property>
    <name>fs.s3a.path.style.access</name>
    <value>true</value>
  </property>
</configuration>
EOF

while ! pg_isready --host ${POSTGRES_HOST} --port ${POSTGRES_PORT}; do echo "Waiting for postgresql to be ready..."; sleep 1; done;

export PGPASSWORD=${HIVEMS_PASSWORD}
psql --host ${POSTGRES_HOST} --port ${POSTGRES_PORT} -U hivems -c "\c hivems"
if [ $? -ne 0 ]
then
  export PGPASSWORD=${POSTGRES_PASSWORD}
  psql -v ON_ERROR_STOP=1  --host ${POSTGRES_HOST} --port ${POSTGRES_PORT} -U postgres <<-EOSQL
      CREATE ROLE hivems ENCRYPTED PASSWORD '${HIVEMS_ENCRYPTED_PASSWORD}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
      CREATE DATABASE hivems;
      GRANT ALL PRIVILEGES ON DATABASE hivems TO hivems;
EOSQL
  ${BASEDIR}/apache-hive-metastore-3.0.0-bin/bin/schematool -initSchema -dbType postgres
fi
unset PGPASSWORD


${BASEDIR}/apache-hive-metastore-3.0.0-bin/bin/start-metastore

