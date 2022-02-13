terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "default"

  default_tags {
    tags = {
      environment = "staging"
      owner       = "ofadiman"
      project     = "fullstack-deployment-to-aws"
      iac         = "terraform"
    }
  }
}
