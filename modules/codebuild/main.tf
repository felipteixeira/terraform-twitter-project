resource "aws_codebuild_project" "codebuild" {
  count         = var.enable
  name          = var.build_name
  description   = "${var.build_name} - Build Project"
  build_timeout = var.build_timeout
  service_role  = var.service_role

  artifacts {
    type = var.artifact_type
  }

  dynamic "cache" {
    for_each = var.enable_cache == false ? [] : [1]
    content {
      type     = var.enable_cache == false ? "NO_CACHE" : var.cache_type
      location = var.cache_bucket
    }
  }

  environment {
    privileged_mode             = var.env_privileged_mode
    compute_type                = var.env_compute_type
    image                       = var.env_image
    type                        = var.env_type
    image_pull_credentials_type = local.ecr_image != false ? "SERVICE_ROLE" : null

    dynamic "environment_variable" {
      for_each = var.environment_variables == [] ? [] : var.environment_variables
      content {
        name  = environment_variable.value["name"]
        value = environment_variable.value["value"]
      }
    }
  }

  source {
    type            = var.source_type
    location        = var.source_location
    git_clone_depth = var.git_clone_depth
    insecure_ssl    = var.insecure_ssl
    buildspec       = var.buildspec_filename != null ? var.buildspec_filename : null
  }


}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  count        = var.enable
  project_name = aws_codebuild_project.codebuild[count.index].name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH, PULL_REQUEST_UPDATED"
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.git_branch
    }

    dynamic "filter" {
      for_each = var.commit_message != "" ? [1] : []
      content {
        type    = "COMMIT_MESSAGE"
        pattern = var.commit_message
      }
    }
  }
}
