/**
 * Defines a Google Cloud Storage bucket and an object within that bucket.
 *
 * The `google_storage_bucket` resource creates a new storage bucket with the
 * specified name, location, and storage class. The `uniform_bucket_level_access`
 * setting enables uniform bucket-level access control.
 *
 * The `google_storage_bucket_object` resource uploads an image file named
 * "mcit.png" to the storage bucket, setting the content type to "text/plain".
 */
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
