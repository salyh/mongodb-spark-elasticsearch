#!/bin/bash
set -e
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
cd /vagrant
mkdir -p _elasticsearch > /dev/null 2>&1
cd _elasticsearch
KIBANA_VERSION=4.3.0
ELASTICSEARCH_VERSION=2.1.0
SPARK_VERSION=1.5.2

if [ ! -f /vagrant/_elasticsearch/spark-$SPARK_VERSION-bin-hadoop2.6.tgz ]
then
  echo "Download Spark"
  wget -nv -q http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop2.6.tgz
  tar -xzf spark-$SPARK_VERSION-bin-hadoop2.6.tgz
  cd spark-$SPARK_VERSION-bin-hadoop2.6
  mkdir 3rdparty
  cd 3rdparty
  wget -nv -q http://central.maven.org/maven2/org/mongodb/mongo-hadoop/mongo-hadoop-core/1.4.2/mongo-hadoop-core-1.4.2.jar
  wget -nv -q https://oss.sonatype.org/content/repositories/releases/org/mongodb/mongo-java-driver/3.1.1/mongo-java-driver-3.1.1.jar
  wget -nv -q http://download.elastic.co/hadoop/elasticsearch-hadoop-2.2.0-beta1.zip
  unzip elasticsearch-hadoop-2.2.0-beta1.zip
  cp elasticsearch-hadoop-2.2.0-beta1/dist/elasticsearch-spark_2.10-2.2.0-beta1.jar .
  cd ..
fi

cd /vagrant/_elasticsearch

if [ ! -f /vagrant/_elasticsearch/kibana-$KIBANA_VERSION-linux-x64.tar.gz ]
then
  echo "Download Elasticsearch/Kibana"
  wget -nv -q https://download.elastic.co/kibana/kibana/kibana-$KIBANA_VERSION-linux-x64.tar.gz
  tar -xzf kibana-$KIBANA_VERSION-linux-x64.tar.gz
  wget -nv -q https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ELASTICSEARCH_VERSION/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz
  tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz
  cd kibana-$KIBANA_VERSION-linux-x64
  bin/kibana plugin --install elasticsearch/marvel/latest
  cd ../elasticsearch-$ELASTICSEARCH_VERSION
  echo "Install Elasticsearch plugins"
  bin/plugin install license
  bin/plugin install marvel-agent
  bin/plugin install lmenezes/elasticsearch-kopf/v2.0.1
fi

cd /vagrant/_elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION

echo "Configuring Elasticsearch"
echo "http.cors.enabled: true" >> config/elasticsearch.yml
echo "http.cors.allow-origin: "'"*"' >> config/elasticsearch.yml
echo "network.bind_host: 0.0.0.0" >> config/elasticsearch.yml

cd /vagrant
echo "To start elasticsearch type nohup /vagrant/start_elasticsearch.sh &"
echo "To start kibana type nohup /vagrant/start_kibana.sh &"
echo "To start spark mongo2es etl type /vagrant/start_sparkshell.sh "
