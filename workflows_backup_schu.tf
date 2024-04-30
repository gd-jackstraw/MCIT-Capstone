# Local values
# Defines a local value for the backup workflow name.
locals {
  backup_workflow_name = "my-backup-workflow"
}

# Create Cloud Storage bucket
# Creates a Google Cloud Storage bucket for storing Firestore backups.
# The bucket is named "mcit-qa-test-qa" and is located in the "us-central1" region.
# The `force_destroy` option is set to `true` to allow the bucket to be deleted even if it contains objects.
resource "google_storage_bucket" "firestore_backups" {
  name          = "mcit-qa-test-qa"
  location      = "us-central1"
  force_destroy = true
}

# Create service account for backups
# Creates a Google Cloud service account named "firestore-backup-account" with the display name "Firestore Backups".
# This service account will be used to perform the Firestore backups.
resource "google_service_account" "backup_account" {
  account_id   = "firestore-backup-account"
  display_name = "Firestore Backups"
}

# Give service account access to bucket
# Grants the "roles/storage.objectAdmin" role to the "firestore-backup-account" service account on the "firestore_backups" Google Cloud Storage bucket.
# This allows the service account to read, write, and delete objects in the bucket.
resource "google_storage_bucket_iam_member" "backup_access" {
  bucket = google_storage_bucket.firestore_backups.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.backup_account.email}"
}

# Archive backup script
# Creates a ZIP archive of the "firestore_backup.py" file, which is the backup script.
# The archived file is stored in the "firestore_backup.zip" file.
data "archive_file" "backup_script" {
  type        = "zip"
  source_file = "./firestore_backup.py"
  output_path = "./firestore_backup.zip"
}

# Upload script to bucket
# Uploads the "firestore_backup.zip" file to the "firestore_backups" Google Cloud Storage bucket.
resource "google_storage_bucket_object" "backup_script" {
  name   = "firestore_backup.zip"
  bucket = google_storage_bucket.firestore_backups.name
  source = data.archive_file.backup_script.output_path
}

# Cloud Workflow to run backup
resource "google_workflows_workflow" "backup_workflow" {
  region = "us-central1"
  name   = "backup-workflow"

  source_contents = <<EOF
steps:
  install_dependencies:
    call: http.post
    args:
      url: https://pypi.org/simple
      auth:
        type: NONE
    body:  
      pip install firebase_admin

  initialize_app:
    call: http.post
    args:
      url: https://us-central1-workflow.endpoints.mcit-qa-test-qa.cloud.goog/initialize_app
      auth:
        type: OIDC
    body:
      initialize_app:

  backup_firestore:
    call: http.post 
    args:
      url: https://us-central1-workflow.endpoints.mcit-qa-test-qa.cloud.goog/backup_firestore
      auth:
        type: OIDC
    body:
      backup_firestore:
        backup_location: gs://${google_storage_bucket.firestore_backups.name}/backup-${formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp())}
EOF

}

# Scheduled workflow
# Creates a Google Cloud Workflow named "mcit-capstone-qa-test-backup-workflow" in the "us-central1" region.
# The workflow source code is base64-encoded and includes the steps to schedule the "my-backup-workflow" workflow to run daily at midnight.
# The workflow is dependent on the "backup_workflow" resource.
resource "google_workflows_workflow" "scheduled_backup" {
  region = "us-central1"
  name   = local.backup_workflow_name
  source_contents = base64encode(<<-EOF
    # Schedule backup workflow

    - projectId: ${var.project_id}
      location: ${var.region}
      name: ${local.backup_workflow_name}
      schedule: "0 0 * * *"
  EOF)
  depends_on = [google_workflows_workflow.backup_workflow]
}
# Local values
locals {
  backup_workflow_name = "my-backup-workflow"
}


  
# Create Cloud Storage bucket
resource "google_storage_bucket" "firestore_backups" {
  name     = "mcit-qa-test-qa"
  location = "us-central1"

  force_destroy = true  
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
  name   = local.backup_workflow_name

  source_contents = base64encode(<<EOF
    # Backup script


    pip install firebase_admin
    python -c "from firebase_admin import initialize_app; initialize_app();"


    from firebase_admin import firestore
    firestore.client().backup('gs://${google_storage_bucket.firestore_backups.name}/backup-${formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp())}')
  EOF)


  service_account = google_service_account.backup_account.email
}


# Store the name of the backup workflow in a variable
# local value
locals {
  backup_workflow_name = mcit-qa-test-qa-backup-workflow
}


# Scheduled workflow
resource "google_workflows_workflow" "scheduled_backup" {
  region = "us-central1"
  name = local.backup_workflow_name

  source_contents = base64encode(<<-EOF
    # Schedule backup workflow


    - projectId: ${var.project_id}
      location: ${var.region}
      name: ${local.backup_workflow_name}
      schedule: "0 0 * * *"
  EOF
  )
  depends_on = [google_workflows_workflow.backup_workflow]
}
