#!/bin/bash

service ssh start

# start cluster
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh 

# create paths and give permissions
#$HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/root/input_answers
#$HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/root/input_names
#$HADOOP_HOME/bin/hdfs dfs -copyFromLocal /data/user_ids_answers input_answers
#$HADOOP_HOME/bin/hdfs dfs -copyFromLocal /data/user_ids_names input_names
$HADOOP_HOME/bin/hdfs dfs -mkdir /spark-logs

# start spark history server
$SPARK_HOME/sbin/start-history-server.sh

# run the spark job
#spark-submit --deploy-mode cluster --master yarn \
#               --class StackAnswer \
#              $SPARK_HOME/jars/stackanswer_2.12-1.0.jar

# copy results from hdfs to local
#$HADOOP_HOME/bin/hdfs dfs -copyToLocal /user/root/users_most_actives /data
#$HADOOP_HOME/bin/hdfs dfs -copyToLocal /user/root/locations_most_actives /data

$HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir       /user
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse

cd /
./root/anaconda2/bin/jupyter-notebook --ip=0.0.0.0 --port=3333 --no-browser --allow-root &
cd /data
echo -e "Runnning..."

#hive --service metastore &
cd /usr/local/hive/scripts/metastore/upgrade/mysql/
schematool -initSchema -dbType mysql
hive --service hiveserver2 &


bash
