variable "helm_config" {
  description = "Repository to Pull charts from"
  type        = map(any)
  default     = {}
}