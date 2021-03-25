terraform {
  required_version = "~> 0.13.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

provider "aws" {
  region  = local.workspace.region
  profile = "techtr00"
}

terraform {
  backend "s3" {
    bucket  = "techtr00-terraform-remote-state"
    key     = "network/terraform.tfstate"
    region  = "us-east-1"
    profile = "techtr00"
  }
}
