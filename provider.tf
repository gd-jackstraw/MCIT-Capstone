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
  credentials = file("<PATH_TO_YOUR_SERVICE_ACCOUNT_JSON>")
  region = "us-east1"
}

resource "google_project_service" "firestore" {
    service = "firestore.googleapis.com"
}

resource "google_project_service" "compute_api" {
  project = google_project.project.project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

provider "google-beta" {
}
