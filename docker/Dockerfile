FROM openjdk:8u242-jre

WORKDIR /opt

ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=3.0.0

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

RUN curl -L https://www-us.apache.org/dist/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf -

RUN curl -L https://jdbc.postgresql.org/download/postgresql-42.2.19.jar -o /opt/apache-hive-metastore-${METASTORE_VERSION}-bin/lib/postgresql-42.2.19.jar

RUN apt-get update && apt-get install -y postgresql-client && apt-get clean

COPY metastore-site.xml ${HIVE_HOME}/conf
COPY metastore.sh /metastore.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /metastore.sh && chmod +x /metastore.sh

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/metastore.sh"]