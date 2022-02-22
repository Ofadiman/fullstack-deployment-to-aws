terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      environment = "staging"
      owner       = "ofadiman"
      project     = "fullstack-deployment-to-aws"
      iac         = "terraform"
    }
  }
}
