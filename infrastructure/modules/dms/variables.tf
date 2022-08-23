variable "allocated_storage" {
  description = "Amount of storage allocated to dms service in GB"
  type        = number
  default     = 50
}

variable "availability_zone" {
  description = "Availability zone for replication instance"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "Engine version for replication instance"
  type        = string
  default     = ""
}

variable "preferred_maintenance_window" {
  description = "Time window for apply routine maintenance"
  type        = string
  default     = ""
}

variable "publicly_accessible" {
  description = "Is the instance publicly accessible"
  type        = bool
  default     = false
}

# aws_rds_cluster
variable "replication_instance_class" {
  description = "EC2 instance class for the replication instance"
  type        = string
  default     = "true"
}

variable "ri_name" {
  description = "Name for the replication instance"
  type        = string
  default     = ""
}

variable "db_subnet_group_name" {
  description = "subnet group for the replication instance"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "So we need to create the security group"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "So we need to create the security group"
  type        = string
  default     = ""
}

variable "dms_env" {
  description = "The acme environment"
  type        = string
  default     = ""
}

variable "source_endpoint_name" {
  description = "Name for the source endpoint"
  type        = string
  default     = ""
}

variable "target_endpoint_name" {
  description = "Name for the target endpoint"
  type        = string
  default     = "finch-dev-kinesis-stream"
}

variable "secrets_manager_arn" {
  description = "Name for the source endpoint"
  type        = string
  default     = ""
}

variable "connection_secret_arn" {
  description = "Name for the source endpoint"
  type        = string
  default     = ""
}

variable "replication_task_id" {
  description = "Name for the source endpoint"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = ""
}

variable "kinesis_stream_arn" {}
variable "service_role_arn" {}
