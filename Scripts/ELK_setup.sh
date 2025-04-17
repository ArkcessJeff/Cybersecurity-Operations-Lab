#!/bin/bash

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Java..."
sudo apt install openjdk-11-jdk -y

echo "Adding Elastic APT repo..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install apt-transport-https -y
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

sudo apt update

echo "Installing Elasticsearch..."
sudo apt install elasticsearch -y
sudo sed -i 's/#network.host: .*/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

echo "Installing Logstash..."
sudo apt install logstash -y

echo "Installing Kibana..."
sudo apt install kibana -y
sudo sed -i 's/#server.host: .*/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml
sudo systemctl enable kibana
sudo systemctl start kibana

echo "Opening firewall ports (5601 Kibana, 5044 Logstash Beats)..."
sudo ufw allow 5601/tcp
sudo ufw allow 5044/tcp

echo "Done! Access Kibana at: http://<your-elk-ip>:5601"
