module "apigw_secrets" {
  source      = "../secrets-manager-secret"
  secret_name = "/${var.project_name}/${var.environment}/apigw_secrets"
  secret_string = jsonencode({
    apigateway-api-id  = aws_apigatewayv2_api.this[0].id
    apigateway-api-arn = aws_apigatewayv2_api.this[0].arn
  })
  tags = var.tags
}

module "apigw_authorizer_secrets" {
  source = "../secrets-manager-secret"

  for_each = var.create && var.create_routes_and_integrations ? { for key, value in aws_apigatewayv2_authorizer.this : key => value } : {}

  secret_name = "/${var.project_name}/${var.environment}/${each.key}/apigw_authorizer_secrets"
  secret_string = jsonencode({
    api-authorizer-id = each.value.id
  })
  tags = var.tags
}
