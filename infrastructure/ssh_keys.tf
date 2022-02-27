resource "tls_private_key" "bastion_host_private_key" {
  algorithm = "RSA"
}

resource "local_file" "bastion_host_local_file" {
  file_permission   = "0400"
  filename          = "bastion-host-key.pem"
  sensitive_content = tls_private_key.bastion_host_private_key.private_key_pem
}

resource "aws_key_pair" "bastion_host_key_pair" {
  key_name   = "bastion-host-key"
  public_key = tls_private_key.bastion_host_private_key.public_key_openssh
}
