terraform {
  backend "local" {}
  required_version = ">= 0.14"
}

provider "aws" {
  region = "us-east-1"
}

locals {
  system_name = "shree_test"
}
