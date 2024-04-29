resource "google_storage_bucket" "static" {
 name          = "capstone-prod-test-bucket"
 project = "mcit-capstone-prod"
 location      = "US"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
}

# Upload an image as an object
# to the storage bucket

resource "google_storage_bucket_object" "default" {
 name         = "mcitlogo"
 source       = "mcit.png"
 content_type = "text/plain"
 bucket       = google_storage_bucket.static.id
}
