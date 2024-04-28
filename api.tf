/* FIRESTORE API */

project = "mcit-capstone-dev"



resource "google_project_service" "firestore" {
    service = "firestore.googleapis.com"
}
