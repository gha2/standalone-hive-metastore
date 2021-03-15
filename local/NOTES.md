
# Setup
cd local
wget https://www-us.apache.org/dist/hive/hive-standalone-metastore-3.0.0/hive-standalone-metastore-3.0.0-bin.tar.gz
tar xvzf hive-standalone-metastore-3.0.0-bin.tar.gz

wget https://apache.mediamirrors.org/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz # Now, not working. Need to manually fetch old release
tar xvzf hadoop-3.2.0.tar.gz
rm hadoop-3.2.0/share/hadoop/common/lib/slf4j-log4j12-1.7.25.jar


mv *.tar.gz archives/


wget https://jdbc.postgresql.org/download/postgresql-42.2.19.jar
mv postgresql-42.2.19.jar apache-hive-metastore-3.0.0-bin/lib/


docker-compose up -d

mc mb local/spark

./metatsore .sh

# Tricks

## Generate postgresql hash password:

python -c "import hashlib; print('md5' + hashlib.md5('password' + 'user').hexdigest())"
python -c "import hashlib; print('md5' + hashlib.md5('ctrlk' + 'ctrlk').hexdigest())"
