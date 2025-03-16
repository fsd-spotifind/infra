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
  access_key = env("AWS_ACCESS_KEY_ID")
  secret_key = env("AWS_SECRET_ACCESS_KEY")
  token      = env("AWS_SESSION_TOKEN")
}