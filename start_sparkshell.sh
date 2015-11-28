#!/bin/bash
cd /vagrant/_elasticsearch/spark-1.5.2-bin-hadoop2.6
cat /vagrant/mongo2elastic.scala | ./bin/spark-shell --master local[2] --jars $(echo ./3rdparty/*.jar | tr ' ' ',')
