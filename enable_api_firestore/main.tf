provider "google" {
  credentials = file("terraform-auth-prod@mcit-capstone-prod.iam.gserviceaccount.com")
  project     = "mcit-capstone-prod"
  region      = "us-central1"
}

resource "google_project_service" "firestore" {
  project = "<YOUR_GCP_PROJECT_ID>"
  service = "firestore.googleapis.com"

  disable_on_destroy = false
}
