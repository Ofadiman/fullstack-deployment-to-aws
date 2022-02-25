terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      environment = "staging"
      owner       = "ofadiman"
      project     = "fullstack_deployment_to_aws"
      iac         = "terraform"
    }
  }
}
