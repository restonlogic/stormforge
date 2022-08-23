module "cognito_secrets" {

  source      = "../secrets-manager-secret"
  secret_name = "/${var.project_name}/${var.environment}/cognito_pool_secrets"
  secret_string = jsonencode({
    user-pool-id       = aws_cognito_user_pool.pool[0].id
    user-pool-endpoint = "https://${aws_cognito_user_pool.pool[0].endpoint}"
    user-pool-arn      = aws_cognito_user_pool.pool[0].arn
  })
  tags = var.tags
}

module "cognito_client_secrets" {
  source = "../secrets-manager-secret"

  for_each = { for key, value in aws_cognito_user_pool_client.client : key => value }

  secret_name = "/${var.project_name}/${var.environment}/${each.value.name}/cognito_client_secrets"
  secret_string = jsonencode({
    user-pool-client-id     = each.value.id
    user-pool-client-secret = each.value.client_secret
  })
  tags = var.tags
}
