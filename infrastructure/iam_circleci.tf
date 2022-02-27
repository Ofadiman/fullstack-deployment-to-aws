resource "aws_iam_user" "circle_ci_user" {
  name = "circle_ci_user"
}

resource "aws_iam_access_key" "circle_ci_user_access_key" {
  user = aws_iam_user.circle_ci_user.name
}

resource "aws_iam_policy" "circle_ci_user_policy" {
  name        = "circle_ci_user_policy"
  description = "Policy tied to the IAM user who deploys the application through CircleCI."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowAllActionsOnECR",
        Action = [
          "ecr:*",
        ]
        Effect   = "Allow"
        Resource = aws_ecr_repository.ecr_repository.arn
      },
      {
        Sid : "AllowDescribeTaskDefinition",
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      # Action ecr:GetAuthorizationToken must be allowed on "*" resource because AWS throws an error.
      {
        Sid : "AllowGetAuthorizationToken",
        Action = [
          "ecr:GetAuthorizationToken",
        ],
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "circle_ci_user_policy_policy_attachment" {
  name       = "circle_ci_user_policy_policy_attachment"
  users      = [aws_iam_user.circle_ci_user.name]
  policy_arn = aws_iam_policy.circle_ci_user_policy.arn
}

output "circle_ci_user_access_key_id" {
  value       = aws_iam_access_key.circle_ci_user_access_key.id
  description = "The access key id used when CircleCI deploys the application."
  sensitive   = true
}

output "circle_ci_user_secret_access_key" {
  value       = aws_iam_access_key.circle_ci_user_access_key.secret
  description = "The secret access key used when CircleCI deploys the application."
  sensitive   = true
}
