##Mongo2ES ETL

* vagrant up
* vagrant ssh
* cd /vagrant
* nohup /vagrant/start_elasticsearch.sh &
* nohup /vagrant/start_kibana.sh &
* nohup /vagrant/start_sparkshell.sh &

Vagrant exposes the ports 9200 and 5601. Open firefox on your host system and type:

* http://localhost:5601/
* http://localhost:9200/

Point Kibana to the "sparkmongo" index.
