resource "aws_cognito_user_group" "main" {
  count        = var.enabled ? length(local.groups) : 0
  name         = lookup(element(local.groups, count.index), "name")
  description  = lookup(element(local.groups, count.index), "description")
  precedence   = lookup(element(local.groups, count.index), "precedence")
  role_arn     = lookup(element(local.groups, count.index), "role_arn")
  user_pool_id = aws_cognito_user_pool.pool[0].id
}

locals {
  groups_default = [
    {
      name        = var.user_group_name
      description = var.user_group_description
      precedence  = var.user_group_precedence
      role_arn    = var.user_group_role_arn

    }
  ]

  # This parses var.user_groups which is a list of objects (map), and transforms it to a tuple of elements to avoid conflict with  the ternary and local.groups_default
  groups_parsed = [for e in var.user_groups : {
    name        = lookup(e, "name", null)
    description = lookup(e, "description", null)
    precedence  = lookup(e, "precedence", null)
    role_arn    = lookup(e, "role_arn", null)
    }
  ]

  groups = length(var.user_groups) == 0 && (var.user_group_name == null || var.user_group_name == "") ? [] : (length(var.user_groups) > 0 ? local.groups_parsed : local.groups_default)

}

resource "aws_ssm_parameter" "cognito_user_group_name" {
  for_each = { for key, value in aws_cognito_user_group.main : key => value }

  name        = "/${var.project_name}/${var.environment}/${lower(each.value.name)}_user_group_name"
  description = "The cognito ${each.value.name} user group name for ${var.project_name} ${var.environment}."
  type        = "String"
  value       = each.value.name
  overwrite   = true

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}