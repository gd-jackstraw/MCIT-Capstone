/*

# Define provider
provider "google" {
    project = "<your-project-id>"
    region  = "<your-region>"
}

# Create Cloud Scheduler job
resource "google_cloud_scheduler_job" "scheduler_job" {
    name        = "my-scheduler-job"
    description = "My Cloud Scheduler Job"
    #schedule    = "*/5 * * * *"
    time_zone   = "America/Los_Angeles"

    http_target {
        uri = "https://example.com/my-task"
    }

    # Define roles and permissions for authorization
    authorization {
        roles = ["roles/cloudscheduler.admin"]
    }
}

# Create Cloud Workflow
resource "google_cloud_workflows_workflow" "workflow" {
    name        = "my-workflow"
    description = "My Cloud Workflow"

    source_code {
        content = <<EOF
            # Cloud Workflow code to create Firestore database and backup in Cloud Storage
            main:
                steps:
                    - createFirestoreDatabase:
                            call: googleapis.firestore.v1.projects.databases.create
                            args:
                                parent: projects/${google_cloud_workflows_workflow.workflow.project_id}
                                requestBody:
                                    createDatabaseRequest:
                                        parent: projects/${google_cloud_workflows_workflow.workflow.project_id}
                                        databaseId: my-database

                    - createBackup:
                            call: googleapis.firestore.v1.projects.databases.collectionGroups.exportDocuments
                            args:
                                name: projects/${google_cloud_workflows_workflow.workflow.project_id}/databases/my-database
                                requestBody:
                                    exportDocumentsRequest:
                                        outputUriPrefix: gs://my-bucket/backup/
        EOF
    }
}


*/
