terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}
provider "google" {
region = "us-east1"
}

provider "google-beta" {
}
