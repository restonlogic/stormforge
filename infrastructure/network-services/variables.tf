variable "vpc_config" {
  type = object({
    name   = string,
    cidr   = string,
    region = string
  })
}

variable "project_config" {}
