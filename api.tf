/* FIRESTORE API */

provider "google" {
    project = "mcit-capstone-dev"
    region  = "us-east1"
}

resource "google_project_service" "firestore" {
    service = "firestore.googleapis.com"
}
