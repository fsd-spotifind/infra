terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }

    backend "remote" {
        organization = "FSD_Spotifind"
        workspaces {
          name = "Spotifind"
        }
    }
}

provider "aws" {
    region = "ap-southeast-1"
}