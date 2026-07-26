
echo -e "${YC}Download and install the public signing key${NC}"
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch


echo -e "${YC}Copy elasticsearch repo ${NC}"
cp home/ec2-user/frontend/elastic/elasticsearch.repo  /etc/yum.repos.d/elastic.repo

echo -e "${YC} install elasticsearch ${NC}"
sudo dnf install --enablerepo=elasticsearch elasticsearch


echo -e "${YC}Start elasticsearch ${NC}"
systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch

