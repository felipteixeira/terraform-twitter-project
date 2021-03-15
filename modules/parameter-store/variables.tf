#SSM Parameter Store Vars.
variable "name" {
  description = "The name"
}

variable "type" {
  description = "The type"
}

variable "value" {
  description = "The value"
}

variable "overwrite" {
  description = "The overwrite"
  default     = true 
}

variable "description" {
  description = "The description"
  default     = null
}