terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.36, !=4.0.0, !=4.1.0, !=4.2.0, !=4.3.0, !=4.4.0, !=4.5.0, !=4.6.0, !=4.7.0, !=4.8.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.1"
    }
  }
}