# !/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname="sravani"
s3_bucket="upgrad-sravani"

sudo apt update -y
sudo apt install apache2
service apache2 status
systemctl enable apache2.service

cd /var/log/apache2/
tar -cf /tmp/${myname}-httpd-logs-${timestamp}.tar *.log

sudo apt update -y
sudo apt install awscli -y

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar