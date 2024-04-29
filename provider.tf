terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}
provider "google" {

  credentials = file("/path/to/service-account.json") 
}


provider "google-beta" {
}
