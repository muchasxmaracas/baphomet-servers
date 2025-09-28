terraform {
  backend "s3" {
    bucket                  = "baphomet-services" # Replace with your bucket name
    key                     = "terraform.tfstate"
    region                  = "fsn1"
    endpoints = {
      s3 = "https://fsn1.your-objectstorage.com"
    }
    skip_metadata_api_check = true
    use_path_style          = true
    skip_region_validation  = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
  }
  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.51.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}