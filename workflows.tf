module "cloud_workflow" {
  source  = "GoogleCloudPlatform/cloud-workflows/google"
  version = "~> 0.1"

  project_id = var.project_id

  workflow_name         = "wf-firestore-backup"
  region                = "us-east1"
  service_account_email = "terraform-auth@mcit-capstone-dev.iam.gserviceaccount.com"
  workflow_trigger = {
    cloud_scheduler = {
      name                  = "workflow-job"
      cron                  = "0 0 * * *"
      time_zone             = "America/New_York"
      deadline              = "320s"
      service_account_email = "terraform-auth@mcit-capstone-dev.iam.gserviceaccount.com"
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

