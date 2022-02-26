# https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331
# https://serverfault.com/questions/556363/what-is-the-difference-between-a-public-and-private-subnet-in-a-amazon-vpc

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  # These 2 attributes set to `true` cause an EC2 instance with a public IP address to also receive a DNS hostname (e.g. ec2-public-ipv4-address.region.compute.amazonaws.com).
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc_fullstack_deployment_to_aws"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_internet_gateway.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_eu_west_1a.id
}

resource "aws_route_table" "private_route_table_for_nat" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat_gateway.id
  }
}

resource "aws_route_table_association" "public_route_table_for_nat_association" {
  route_table_id = aws_route_table.private_route_table_for_nat.id
  subnet_id      = aws_subnet.private_subnet_eu_west_1a.id
}

resource "aws_subnet" "public_subnet_eu_west_1a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_eu_west_1a"
  }
}

resource "aws_subnet" "public_subnet_eu_west_1b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_eu_west_1a"
  }
}

resource "aws_subnet" "private_subnet_eu_west_1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "private_subnet_eu_west_1a"
  }
}

resource "aws_subnet" "database_subnet_eu_west_1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "database_subnet_eu_west_1a"
  }
}

resource "aws_subnet" "database_subnet_eu_west_1b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "database_subnet_eu_west_1b"
  }
}

resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_internet_gateway"
  }
}

resource "aws_eip" "nat_gateway_ip" {
  vpc = true
  # Internet Gateway MUST be present in the VPC for EIP to work.
  depends_on = [aws_internet_gateway.main_internet_gateway]
}

resource "aws_nat_gateway" "public_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.public_subnet_eu_west_1a.id
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_internet_gateway]
}
