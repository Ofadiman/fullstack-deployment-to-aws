# Continuous integration

`Continuous integration` is the process by which code is deployed to a staging or production environment without programmer intervention.

## CI/CD pipeline

There are many tools we can use to create a CI/CD pipeline. I will be using [CircleCI](https://circleci.com/), but tools like [GitHub Actions](https://docs.github.com/en/actions), [Jenkins](https://www.jenkins.io/), etc. are also suitable for implementing CI/CD pipelines.

The most common CI/CD flow looks like this:

1. Download the code from the repository to the CI server.
2. Install the dependencies present in the project.
3. Run automated tests, linters, code formatters, etc.
4. Build docker images.
5. Push images to remote docker repositories (e.g. DockerHub, ECR).
6. Update the docker image in the service that runs the application (e.g. ECS).

## Infrastructure

At this stage, you need to have at least an ECR repository. The ECR configuration can be found in the `infrastructure/ecr.tf` file.
