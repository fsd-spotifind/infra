terraform {
    backend "remote" {
        organization = "FSD-Spotifind"
        workspaces {
          name = "Spotifind"
        }
    }
}

provider "aws" {
  region  = "ap-southeast-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN

#   # You can also set `skip_credentials_validation` to true to prevent Terraform from trying to validate credentials.
#   skip_credentials_validation = true
}