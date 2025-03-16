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
}