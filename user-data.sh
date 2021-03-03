#!/bin/bash

yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
echo `hostname` > /var/www/html/index.html
echo '<br><br>' >> /var/www/html/index.html
# create ~ 12K of random text
base64 /dev/urandom | head -c 10000 >> /var/www/html/index.html
