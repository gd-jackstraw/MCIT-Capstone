/* module "cloud_workflow" {
  source  = "GoogleCloudPlatform/cloud-workflows/google"
  version = "~> 0.1"

  workflow_name         = "wf-firestore-backup"
  region                = "us-east1"
  service_account_email = "<svc_account>"
  workflow_trigger = {
    cloud_scheduler = {
      name                  = "workflow-job"
#      cron                  = "*/3 * * * *"
 #     time_zone             = "America/New_York"
  #    deadline              = "320s"
      service_account_email = "<svc_account>"
    }
  }
  workflow_source       = <<-EOF
  - getCurrentTime:
      call: http.get
      args:
          url: https://us-central1-workflowsample.cloudfunctions.net/datetime
      result: CurrentDateTime
  - readWikipedia:
      call: http.get
      args:
          url: https://en.wikipedia.org/w/api.php
          query:
              action: opensearch
              search: $${CurrentDateTime.body.dayOfTheWeek}
      result: WikiResult
  - returnOutput:
      return: $${WikiResult.body[1]}
EOF
}

*/
