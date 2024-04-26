

resource "google_storage_bucket" "static" {
  name         = "gcp_capstone"
  location      = "us-central1"
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

resource "google_storage_bucket_object" "static" {
  name         = "OBJECT_NAME"
  source       = "OBJECT_PATH"
  content_type = "text/plain"
  bucket       = google_storage_bucket.static.id
}
