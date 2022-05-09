#! /bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install python3 -y
pip3 install ec2instanceconnectcli
eval "$(mssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  \
    --region ${AWS::Region} ${DockerManager1} docker swarm join-token manager | grep -i 'docker')"
# uninstall aws cli version 1
rm -rf /bin/aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
yum install amazon-ecr-credential-helper -y
mkdir -p /home/ec2-user/.docker
cd /home/ec2-user/.docker
echo '{"credsStore": "ecr-login"}' > config.json