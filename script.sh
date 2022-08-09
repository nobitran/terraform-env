#!/bin/bash -xe
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo docker run -d -p 8080:80 nginx
echo "Hello World." >> demo.txt