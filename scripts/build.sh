#!/usr/bin/env bash

# Script for building docker image locally for debug purposes.
docker build --file prod.Dockerfile --tag fullstack-deployment-to-aws .
