locals {
  integrations = {

    "GET /hello" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      authorizer_key         = "cognito"
      # integration_type    = "AWS_PROXY"
      # integration_subtype    = "POST"
    }

    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
      tls_config = jsonencode({
        server_name_to_verify = "api.${var.environment}.${var.domain_name}"
      })

      response_parameters = jsonencode([
        {
          status_code = 500
          mappings = {
            "append:header.header1" = "$context.requestId"
            "overwrite:statuscode"  = "403"
          }
        },
        {
          status_code = 404
          mappings = {
            "append:header.error" = "$stageVariables.environmentId"
          }
        }
      ])
    }
  }
}