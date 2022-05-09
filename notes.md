## Infrastructure

- Public Github Repository

- Docker Swarm

  - 3 Manager nodes

  - 2 Worker nodes

    - Each of the nodes should communicate with the other nodes via Docker Swarm

    - EC2 instance to connect CLI

    - IAM policy

  - Leader manager node can pull/push image from/to ECR.

  - Full-Access ECR policy for the instances.

  - Other manager and worker nodes can pull image from ECR.

- AWS ECR to be created for image registry.

- CloudFormation template to be created for the infrastructure.

## Application

- `Dockerfile`

  - Will be used for the app-server image

  - Required files:

    - `phonebook-app.py`

    - `requirements.txt`

    - `templates` folder

- `docker-compose.yml`

  - Services:

    - app-server and MySQL

    - app-server image will be pulled from ECR.
