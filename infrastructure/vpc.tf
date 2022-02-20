module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "fullstack-deployment-to-aws"
  cidr = "20.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["20.0.1.0/24", "20.0.2.0/24"]
  public_subnets  = ["20.0.11.0/24", "20.0.12.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  database_subnets                   = ["20.0.21.0/24", "20.0.22.0/24"]
}
