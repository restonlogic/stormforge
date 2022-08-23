variable "environment" {
  description = "Environment name"
  type        = string
  default     = null
}

variable "namespace" {
  type = string
}

variable "labels" {
  type    = map(any)
  default = {}
}
