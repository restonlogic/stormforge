#locals {
#  db_subnet_group_name          = var.create_db_subnet_group ? join("", aws_db_subnet_group.this.*.name) : var.db_subnet_group_name
#  
#  internal_db_subnet_group_name = try(coalesce(var.db_subnet_group_name, var.name), "")
#  
#  rds_security_group_id       = join("", aws_security_group.this.*.id)
#}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Create Subnet Group
resource "aws_dms_replication_subnet_group" "sg" {

  count = var.dms_env == "mgmt" ? 0 : 1

  replication_subnet_group_description = "${var.dms_env} replication subnet group"
  replication_subnet_group_id          = "${var.dms_env}-dms-replication-subnet-group"

  subnet_ids = data.aws_subnets.subnets.ids

  tags = {
    Name = "${var.dms_env}"
  }
}

# Create a new replication instance
resource "aws_dms_replication_instance" "this" {
  count = var.dms_env == "mgmt" ? 0 : 1

  allocated_storage            = var.allocated_storage
  availability_zone            = var.availability_zone
  engine_version               = var.engine_version
  preferred_maintenance_window = var.preferred_maintenance_window
  publicly_accessible          = var.publicly_accessible
  replication_instance_class   = var.replication_instance_class
  replication_instance_id      = var.ri_name
  replication_subnet_group_id  = aws_dms_replication_subnet_group.sg[count.index].id

  #  tags = {
  #    Name = var.tag_name
  #  }

  vpc_security_group_ids = var.vpc_security_group_ids

}

resource "aws_dms_endpoint" "this" {
  count = var.dms_env == "mgmt" ? 0 : 1

  database_name                   = "${var.dms_env}db"
  endpoint_id                     = var.source_endpoint_name
  endpoint_type                   = "source"
  engine_name                     = "postgres"
  ssl_mode                        = "none"
  secrets_manager_access_role_arn = var.secrets_manager_arn
  secrets_manager_arn             = var.connection_secret_arn

}

resource "aws_dms_endpoint" "kinesis_endpoint" {
  count         = var.dms_env == "mgmt" ? 0 : 1
  endpoint_id   = "${var.target_endpoint_name}-${var.dms_env}"
  endpoint_type = "target"
  engine_name   = "kinesis"
  ssl_mode      = "none"
  kinesis_settings {
    stream_arn              = var.kinesis_stream_arn
    service_access_role_arn = var.service_role_arn
  }
}

# Create a new replication task
resource "aws_dms_replication_task" "replication_task" {
  count                    = var.dms_env == "mgmt" ? 0 : 1
  migration_type           = "full-load-and-cdc"
  replication_instance_arn = aws_dms_replication_instance.this[count.index].replication_instance_arn
  replication_task_id      = var.replication_task_id
  source_endpoint_arn      = aws_dms_endpoint.this[count.index].endpoint_arn
  table_mappings           = file("${path.module}/mapping_rules.json")
  start_replication_task   = true

  tags = {
    Name = "test"
  }

  target_endpoint_arn = aws_dms_endpoint.kinesis_endpoint[count.index].endpoint_arn

  depends_on = [
    aws_dms_replication_instance.this,
    aws_dms_endpoint.this,
    aws_dms_endpoint.kinesis_endpoint
  ]
  lifecycle {
    ignore_changes = [replication_task_settings]
  }
}