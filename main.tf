# Create Cloud Storage bucket
resource "google_storage_bucket" "firestore_backups" {
  name     = "mcit-capstone-qa-test"
  location = "US"
}

# Create service account for backups
resource "google_service_account" "backup_account" {
  account_id   = "firestore-backup-account"
  display_name = "Firestore Backups"
}

# Give service account access to bucket
resource "google_storage_bucket_iam_member" "backup_access" {
  bucket = google_storage_bucket.firestore_backups.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.backup_account.email}"
}

# Archive backup script
data "archive_file" "backup_script" {
  type        = "zip"
  source_file = "./firestore_backup.py"
  output_path = "./firestore_backup.zip"
}

# Upload script to bucket
resource "google_storage_bucket_object" "backup_script" {
  name   = "firestore_backup.zip"
  bucket = google_storage_bucket.firestore_backups.name
  source = data.archive_file.backup_script.output_path
}

# Cloud Workflow to run backup
resource "google_workflows_workflow" "backup_workflow" {
  region = "us-central1"

  source_contents = base64encode(<<EOF
    # Backup script

    pip install firebase_admin
    python -c "from firebase_admin import initialize_app; initialize_app();"

    from firebase_admin import firestore
    firestore.client().backup('gs://${google_storage_bucket.firestore_backups.name}/backup-${formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp())}')
  EOF)

  service_account = google_service_account.backup_account.email
}

# Scheduled workflow
resource "google_workflows_workflow" "scheduled_backup" {
  region = "us-central1"

  source_contents = base64encode(<<EOF
    # Schedule backup workflow

    - projectId: ${var.project_id}
      location: ${var.region}
      name: ${google_workflows_workflow.backup_workflow.name}
      schedule: "0 0 * * *"
  EOF)

  depends_on = [google_workflows_workflow.backup_workflow]
}
