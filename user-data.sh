#!/bin/bash -xe
# run default with root
yum update -y
yum install -y docker
systemctl start docker
usermod -aG docker ec2-user
docker run -d -p 8080:80 nginx
echo "Hello World." >> demo.txt