#!/usr/bin/env bash

# Script for running staging/production docker image locally for debug purposes.
docker run --network=fullstack-deployment-to-aws_default -it -p 3000:3000 \
  -e "NODE_ENV=staging" \
  -e "POSTGRES_DATABASE=postgres" \
  -e "POSTGRES_HOST=database" \
  -e "POSTGRES_PASSWORD=postgres" \
  -e "POSTGRES_PORT=5432" \
  -e "POSTGRES_USER=postgres" \
  -e "SERVER_PORT=3000" \
  fullstack-deployment-to-aws
