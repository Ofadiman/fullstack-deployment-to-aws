resource "aws_security_group" "bastion_security_group" {
  description = "Security Group used for EC2 Bastion Host to allow SSH traffic."
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_instance" "bastion_host" {
  ami                         = "ami-07e30a3659a490be7"
  associate_public_ip_address = true
  instance_type               = "t4g.nano"
  key_name                    = aws_key_pair.bastion_host_key_pair.key_name
  subnet_id                   = aws_subnet.public_subnet_eu_west_1a.id
  vpc_security_group_ids      = [aws_security_group.bastion_security_group.id]

  # Copy SSH key file into home directory on EC2 instance.
  provisioner "file" {
    destination = "/home/ec2-user/${aws_key_pair.bastion_host_key_pair.key_name}.pem"
    source      = "./${aws_key_pair.bastion_host_key_pair.key_name}.pem"

    connection {
      host        = self.public_ip
      private_key = file("${aws_key_pair.bastion_host_key_pair.key_name}.pem")
      type        = "ssh"
      user        = "ec2-user"
    }
  }

  // chmod key 400 on EC2 instance
  provisioner "remote-exec" {
    inline = ["chmod 400 ~/${aws_key_pair.bastion_host_key_pair.key_name}.pem"]

    connection {
      host        = self.public_ip
      private_key = file("${aws_key_pair.bastion_host_key_pair.key_name}.pem")
      type        = "ssh"
      user        = "ec2-user"
    }
  }
}
