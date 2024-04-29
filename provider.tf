terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.53, < 5.0"
    }
  }
}

  provider "google" {
    project = "mcit-capstone-dev"
    region = "us-east1"
}

resource "google_project_service" "firestore" {
    project = "mcit-capstone-dev"
    service = "firestore.googleapis.com"
}

resource "google_project_service" "workflows" {
    project = "mcit-capstone-dev"
    service = "workflows.googleapis.com"
}

resource "google_project_service" "scheduler" {
    project = "mcit-capstone-dev"
    service = "cloudscheduler.googleapis.com"
}

resource "google_project_service" "compute_api" {
  project = "mcit-capstone-dev"
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

provider "google-beta" {
}

