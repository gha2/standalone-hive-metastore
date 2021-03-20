FROM openjdk:8u242-jre

WORKDIR /opt

ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=3.0.0

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

RUN curl -L https://downloads.apache.org/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    rm -f hadoop-${HADOOP_VERSION}/share/hadoop/common/lib/slf4j-log4j12-*.jar

RUN curl -L https://jdbc.postgresql.org/download/postgresql-42.2.19.jar -o /opt/apache-hive-metastore-${METASTORE_VERSION}-bin/lib/postgresql-42.2.19.jar

RUN apt-get update && apt-get install -y postgresql-client sudo && apt-get clean

COPY metastore.sh /metastore.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /metastore.sh && chmod +x /metastore.sh

# Security breach, but must be in a namespace with relaxed psp to be able to sudo
COPY hive.sudoer /etc/sudoers.d/hive

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/metastore.sh"]

