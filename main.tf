resource "google_storage_bucket" "bucket" {
  name                        = var.name
  project                     = var.project_id
  location                    = var.location
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.bucket_policy_only
  labels                      = var.labels
  force_destroy               = var.force_destroy
  public_access_prevention    = var.public_access_prevention

  versioning {
    enabled = var.versioning
  }

  autoclass {
    enabled = var.autoclass
  }

  retention_policy {
    retention_period = var.retention_period_seconds
  }
}


module "cloud_workflow" {
  source  = "GoogleCloudPlatform/cloud-workflows/google"
  version = "~> 0.1"

  project_id = var.project_id

  workflow_name         = var.workflow_name
  region                = var.region
  service_account_email = var.service_account_email
  workflow_trigger = {
    cloud_scheduler = {
      name                  = "workflow-job"
      cron                  = "0 0 * * *"
      time_zone             = "America/New_York"
      deadline              = "320s"
      service_account_email = var.service_account_email
    }
  }
  workflow_source       = <<-EOF

- initialize:
    assign:
      - project: $${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
      - firestoreDatabaseId: (default)
      - firestoreBackupBucket: gs://${google_storage_bucket.bucket.name}
- exportFirestoreDatabaseAll:
    call: http.post
    args:
      url: $${"https://firestore.googleapis.com/v1/projects/"+project+"/databases/"+firestoreDatabaseId+":exportDocuments"}
      auth:
        type: OAuth2
      body:
        outputUriPrefix: $${firestoreBackupBucket}
    result: result
- returnResult:
    return: $${result}

EOF


}
