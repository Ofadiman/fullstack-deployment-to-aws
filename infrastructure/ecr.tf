resource "aws_ecr_repository" "ecr_repository" {
  name = "fullstack_deployment_to_aws"
}

output "ecr_name" {
  value = aws_ecr_repository.ecr_repository.name
  description = "ECR repository name."
}
