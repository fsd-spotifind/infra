resource "aws_ssm_parameter" "ecs_secrets" {
  name = "/spotifind/ecs/secrets"
  type = "SecureString"
  value = jsonencode({
    port            = var.port
    app_env         = var.app_env
    db_host         = var.db_host
    db_port         = var.db_port
    db_database     = var.db_database
    db_username     = var.db_username
    db_password     = var.db_password
    db_schema       = var.db_schema
    github_ref_name = var.github_ref_name
    database_url    = var.database_url
    jwt_secret      = var.jwt_secret
  })
}

resource "aws_iam_policy" "ssm_read_policy" {
  name = "ecs-ssm-read-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameter"
        Resource = aws_ssm_parameter.ecs_secrets.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}