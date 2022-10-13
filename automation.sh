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

filesize=$(stat -c%s /tmp/${myname}-httpd-logs-${timestamp}.tar)

if [ -e /var/www/html/inventory.html ]
then
	
    VAR=$(echo "<td>httpd-logs &nbsp;</td> <td>${timestamp} &nbsp;</td> <td>tar &nbsp;</td> <td>${filesize}</td>")
	sed -i -e "$ i <tr>" -e "$ i $VAR" -e "$ i </tr>" /var/www/html/inventory.html
else
	
    echo "<table>" >> /var/www/html/inventory.html
	echo "<tr>" >> /var/www/html/inventory.html
	echo "<td> <b>Log Type </b>&nbsp; </td>" >> /var/www/html/inventory.html
	echo "<td> <b>Time Created </b>&nbsp;</td>" >> /var/www/html/inventory.html
	echo "<td> <b>Type </b>&nbsp; </td>" >> /var/www/html/inventory.html
	echo "<td> <b>Size </b> </td>" >> /var/www/html/inventory.html
	echo "</tr>" >> /var/www/html/inventory.html
	echo "<tr><td>httpd-logs &nbsp;</td> <td>${timestamp}&nbsp;</td> <td>tar</td> <td>${filesize} &nbsp;</td></tr>" >> /var/www/html/inventory.html
	echo "</table>" >> /var/www/html/inventory.html
fi

sudo echo "10 16 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
sudo chmod 600 /etc/cron.d/automation