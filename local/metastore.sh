#!/bin/sh

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export JAVA_HOME=/usr/local/opt/openjdk/

export BASEDIR=${MYDIR}

export POSTGRES_PASSWORD=postgres
export HIVEMS_PASSWORD=hivems
export HIVEMS_ENCRYPTED_PASSWORD=md54507e4128ef7e8b157fa8aeb399035f0
export POSTGRES_HOST=tcp1.shared1
export POSTGRES_PORT=15432

export LOG_LEVEL=INFO

#export S3_ENDPOINT=http://localhost:9000
#export S3_ACCESS_KEY=accesskey
#export S3_SECRET_KEY=secretkey

export S3_ENDPOINT=https://minio1.shared1
export S3_ACCESS_KEY=minio
export S3_SECRET_KEY=minio123

. ${MYDIR}/../docker/metastore.sh
