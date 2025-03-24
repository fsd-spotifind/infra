resource "aws_ssm_parameter" "env_vars" {
  for_each = {
    "PORT" = var.port,
    "JWT_SECRET" = var.jwt_secret,
    "DATABASE_URL" = var.database_url
  }
  name = "/spotifind/${each.key}"
  type = "SecureString"
  value = each.value
}

resource "aws_iam_policy" "ssm_policy" {
  name   = "ecs-ssm-parameter-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ssm:GetParameter", "ssm:GetParameters"]
        Effect   = "Allow"
        Resource = [
          for param in aws_ssm_parameter.env_vars : param.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}