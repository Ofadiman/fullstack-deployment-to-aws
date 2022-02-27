# Fullstack deployment to AWS

The project shows how to deploy a full stack application on Amazon Web Services using CI/CD tools. Frontend is an SPA application written in [React](https://reactjs.org/), backend is a typical Node.js server written in [NestJS](https://nestjs.com/). A popular open-source relational database [PostgreSQL](https://www.postgresql.org/) was also used in the project. Continuous integration and deployment processes are covered by [CircleCI](https://circleci.com/) service.

## Continuous integration

There are many tools we can use to create a CI/CD pipeline. I'm using [CircleCI](https://circleci.com/), but tools like [GitHub Actions](https://docs.github.com/en/actions), [Jenkins](https://www.jenkins.io/), etc. are also suitable for implementing CI/CD pipelines.

Every continuous integration pipeline consists of:

1. Running tests.
2. Building packages.

There are 2 additional steps that are happening only on certain branch (e.g. production):

1. Build a docker image and upload it to ECR.
2. Update the task definition on ECS to deploy the new version of the application from ECR's image.

## Infrastructure

The project uses a so-called 3-tier architecture. A network stack is built contains VPC with public, private, and database subnets.

1. The public subnets host an [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) that routes traffic to the private subnet hosting the applications. Security groups are configured to allow all traffic from the internet on ports 80 and 443.
2. The private subnets host application tier. The Node.js application runs in a docker container running in [ECS](https://aws.amazon.com/ecs/) Cluster. Security groups are configured to allow traffic from ALB security group only on port 80.
3. The database subnets host [RDS](https://aws.amazon.com/rds/) database for PostgreSQL. Security groups are configured to allow traffic from application security groups on port 5432 (PostgreSQL default port).

## Database access

The database lives within private subnets which means it does not have a public IP address. To allow connections to the database from developer machines, there is a so-called [Bastion Host](https://en.wikipedia.org/wiki/Bastion_host) in the public subnet. If you want to create an SSH tunnel that will forward your connection to the database through Bastion Host use [tunnelDatabaseConnection.sh](/scripts/tunnelDatabaseConnection.sh) script.
