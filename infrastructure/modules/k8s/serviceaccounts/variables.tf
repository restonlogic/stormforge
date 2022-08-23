variable "environment" {
  description = "Environment name"
  type        = string
  default     = null
}

variable "annotations" {
  description = "Annotations"
  type        = map(any)
  default     = {}
}

variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "labels" {
  type    = map(any)
  default = {}
}

variable "automount_service_account_token" {
  type    = bool
  default = true
}