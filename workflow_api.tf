resource "google_workflow" "example" {
  name          = "example-workflow"
  description   = "Example workflow"
  project       = "mcit-capstone-prod"
  region        = "us-central1"
  service_account = google_service_account.example.email

  entry_point = "main"

  steps = [
    {
      name = "step1"
      param_yaml = <<YAML
        inputs:
          - name: message
            value: "Hello, world!"
      template = "builtin/echo"
    },
    {
      name = "step2"
      template = "builtin/sleep"
      parameters = {
        time = "10s"
      }
    },
    {
      name = "step3"
      template = "builtin/echo"
      parameters = {
        message = "Goodbye, world!"
      }
    }
  ]

  YAML
}
