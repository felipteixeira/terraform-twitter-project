#Codebuild Vars.

variable "build_name" {
  description = "The build_name"
}

variable "build_timeout" {
  default = "10"
}

variable "service_role" {
  description = "The service_role"
}

variable "artifact_type" {
  description = "The artifacts_type"
  default     = "NO_ARTIFACTS"
}

variable "cache_type" {
  description = "The cache_type"
  default     = "S3"
}

variable "cache_bucket" {
  description = "The cache_bucket"
  default     = ""
}

variable "env_privileged_mode" {
  description = "The env_privileged_mode"
  default     = true
}

variable "env_compute_type" {
  description = "The env_compute_type"
  default     = "BUILD_GENERAL1_SMALL"
}

variable "env_image" {
  description = "The env_image"
  default     = "aws/codebuild/java:openjdk-8"
}

locals {
  ecr_image = contains(split(".", var.env_image), "ecr")
}

variable "env_type" {
  description = "The env_type"
  default     = "LINUX_CONTAINER"
}

variable "image_from_ecr" {
  description = "The image_from_ecr"
  type        = bool
  default     = false
}

variable "source_type" {
  description = "The source_type"
  default     = "GITHUB"
}

variable "source_location" {
  description = "The source_location"
}

variable "git_clone_depth" {
  description = "The git_clone_depth"
  default     = "1"
}

variable "insecure_ssl" {
  description = "The insecure_ssl"
  default     = false
}

variable "buildspec_filename" {
  description = "The buildspec_filename"
  default     = null
}

variable "git_branch" {
  description = "The git_branch"
}

variable "commit_message" {
  description = "The commit_message"
  default = ""
}

variable "environment_variables" {
  description = "The environment_variables"
  type        = list(any)
  default     = []
}

variable "enable_cache" {
  description = "The enable_cache"
  default     = true
}

variable "enable" {
  description = "Enable Service"
  default     = 1
  type = number
}