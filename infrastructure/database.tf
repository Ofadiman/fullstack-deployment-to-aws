resource "aws_db_subnet_group" "database_subnet_group" {
  name = "database_subnet_group"
  # AWS requires to have at least 2 subnets here (probably for multi-AZ).
  subnet_ids = [aws_subnet.database_subnet_eu_west_1a.id, aws_subnet.database_subnet_eu_west_1b.id]

  tags = {
    Name = "database_subnet_group"
  }
}

resource "random_password" "database_password" {
  length  = 16
  special = false
}

resource "aws_security_group" "database_security_group" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.main_ecs_service_security_group.id, aws_security_group.bastion_security_group.id]
  }

  # Terraform requires to explicitly specify egress rule that allows outbound traffic to the internet.
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "database" {
  db_name  = "postgres"
  password = random_password.database_password.result
  username = "ofadiman"

  allocated_storage     = 20
  availability_zone     = "eu-west-1a"
  db_subnet_group_name  = aws_db_subnet_group.database_subnet_group.name
  engine                = "postgres"
  engine_version        = "13.4"
  instance_class        = "db.t4g.micro"
  max_allocated_storage = 30
  multi_az              = false
  skip_final_snapshot   = true

  vpc_security_group_ids = [aws_security_group.database_security_group.id]

  # I think this is how the default encryption is defined.
  storage_encrypted = true

  # I don't want any backups for now.
  backup_retention_period = 0

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

output "database_password" {
  value       = random_password.database_password.result
  description = "PostgreSQL database password."
  sensitive   = true
}
