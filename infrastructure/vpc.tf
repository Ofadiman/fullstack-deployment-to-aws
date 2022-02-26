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

resource "aws_security_group" "security_group_allow_http_ssh" {
  name        = "my_web_security"
  description = "Allow http,ssh,icmp"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}