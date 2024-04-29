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
