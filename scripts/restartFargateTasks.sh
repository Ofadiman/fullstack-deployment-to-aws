#!/usr/bin/env bash

aws-vault exec ofadiman -- aws ecs update-service --force-new-deployment --service MainEcsService --cluster MainEcsCluster
