#! /bin/bash
yum update -y
hostnamectl set-hostname Grand-Master
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker swarm init
aws ecr get-login-password --region ${AWS::Region} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
docker service create \
    --name=viz \
    --publish=8080:8080/tcp \
    --constraint=node.role==manager \
    --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    dockersamples/visualizer
yum install git -y
# uninstall aws cli version 1
rm -rf /bin/aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
yum install amazon-ecr-credential-helper -y
mkdir -p /home/ec2-user/.docker
cd /home/ec2-user/.docker
echo '{"credsStore": "ecr-login"}' > config.json
aws ecr create-repository \
    --repository-name ${APP_REPO_NAME} \
    --image-scanning-configuration scanOnPush=false \
    --image-tag-mutability MUTABLE \
    --region ${AWS::Region}
docker build --force-rm -t "${ECR_REGISTRY}/${APP_REPO_NAME}:latest" ${GITHUB_REPO}
docker push "${ECR_REGISTRY}/${APP_REPO_NAME}:latest"
mkdir -p /home/ec2-user/phonebook
cd /home/ec2-user/phonebook
cat << EOF | tee .env
ECR_REGISTRY=${ECR_REGISTRY}
APP_REPO_NAME=${APP_REPO_NAME}
EOF
curl -o "docker-compose.yml" -L ${GIT_FILE_URL}docker-compose.yml
curl -o "init.sql" -L ${GIT_FILE_URL}init.sql
docker-compose config | docker stack deploy --with-registry-auth -c - phonebook