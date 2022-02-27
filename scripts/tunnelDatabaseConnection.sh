#!/usr/bin/env bash

ssh -i ../infrastructure/bastion-host-key.pem -L 8500:terraform-20220225115143983300000001.ct7oqhqcsqip.eu-west-1.rds.amazonaws.com:5432 ec2-user@ec2-54-171-131-146.eu-west-1.compute.amazonaws.com
