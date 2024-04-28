terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}
provider "google" {
  project = "mcit-capstone-dev"
  region = "us-east1"
}

resource "google_project_service" "firestore" {
    service = "firestore.googleapis.com"
}


provider "google-beta" {
}
