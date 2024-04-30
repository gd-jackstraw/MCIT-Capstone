# Enables various Google Cloud APIs for a project and creates an App Engine application.

# Enables the Firestore API for the "mcit-capstone-prod" project.
resource "google_project_service" "firestore" {
  project = "mcit-capstone-prod" 
  service = "firestore.googleapis.com"
}

# Enables the Compute Engine API for the "mcit-capstone-prod" project.
resource "google_project_service" "compute_engine" {
  project = "mcit-capstone-prod"
  service = "compute.googleapis.com"
}  

# Enables the Workflows API for the "mcit-capstone-prod" project.
resource "google_project_service" "workflows" {
  project = "mcit-capstone-prod"
  service = "workflows.googleapis.com"
}

# Enables the Cloud Scheduler API for the "mcit-capstone-prod" project.
resource "google_project_service" "cloud_scheduler" {
  project = "mcit-capstone-prod"
  service = "cloudscheduler.googleapis.com"
}

# Creates an App Engine application in the "us-central" location, with dependencies on the
# enabled APIs.
resource "google_app_engine_application" "app" {
  location_id = "us-central"

  depends_on = [
    google_project_service.firestore,
    google_project_service.compute_engine, 
    google_project_service.workflows,
    google_project_service.cloud_scheduler
  ]
}
# Enable Firestore API
resource "google_project_service" "firestore" {
  project = "mcit-capstone-prod" 
  service = "firestore.googleapis.com"
}

# Enable Compute Engine API
resource "google_project_service" "compute_engine" {
  project = "mcit-capstone-prod"
  service = "compute.googleapis.com"
}  

# Enable Workflows API  
resource "google_project_service" "workflows" {
  project = "mcit-capstone-prod"
  service = "workflows.googleapis.com"
}

# Enable Cloud Scheduler API
resource "google_project_service" "cloud_scheduler" {
  project = "mcit-capstone-prod"
  service = "cloudscheduler.googleapis.com"
}

# Create App Engine app
resource "google_app_engine_application" "app" {
  location_id = "us-central"

  depends_on = [
    google_project_service.firestore,
    google_project_service.compute_engine, 
    google_project_service.workflows,
    google_project_service.cloud_scheduler
  ]
}
