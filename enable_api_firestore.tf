
resource "google_project_service" "firestore" {
  project = "mcit-capstone-prod"
  service = "firestore.googleapis.com"

  disable_on_destroy = false
}


resource "google_storage_bucket" "static" {
  name         = "gcp_capstone"

  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  }
  depends_on = [
    google_project_iam_member.default
  ]
}

resource "google_project_iam_member" "default" {
  project = "mcit-capstone-prod"
  role    = "roles/storage.admin"
  member  = "serviceAccount:terraform@${google_project.project.number}.iam.gserviceaccount.com"
}

resource "google_kms_crypto_key" "terraform_state_bucket" {
  name     = "terraform-state-bucket-key"
  location = "us-central1"
}


resource "google_project" "project" {
  name               = "mcit-capstone-prod"
  project_id         = "mcit-capstone-prod"
  billing_account    = "012345-6789ABCDEF0"
  auto_create_network = true
}

resource "google_project_service" "firestore" {
  project = google_project.project.project_id
  service = "firestore.googleapis.com"

  disable_on_destroy = false
}

# ... other resources ...
