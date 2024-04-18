module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  name       = "dev-test-bucket12864"
  project_id = "mcit-capstone-dev"
  location   = "us-east1"
  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "terraform-auth@mcit-capstone-dev.iam.gserviceaccount.com"
  }]
}

resource "google_storage_bucket_iam_member" "members" {
  for_each = {
    for m in var.iam_members : "${m.role} ${m.member}" => m
  }
  bucket = google_storage_bucket.bucket.name
  role   = each.value.role
  member = each.value.member
}
