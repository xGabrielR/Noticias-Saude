terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.7.0"
    }

    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "1.0.5"
    }

  }

  # backend "s3" { }
}

provider "aws" {
  region = var.default_region
}

provider "snowflake" {
  organization_name = "ORGANIZATION"  # fetch from AWS Secret Manager using AWS Provider
  account_name      = "ACCOUNT"       # fetch from AWS Secret Manager using AWS Provider
  user              = "ADMINUSER"     # fetch from AWS Secret Manager using AWS Provider
  password          = "ADMINPASSWORD" # fetch from AWS Secret Manager using AWS Provider

  preview_features_enabled = [
    "snowflake_procedure_python_resource",
    "snowflake_file_format_resource",
    "snowflake_stage_resource"
  ]
}