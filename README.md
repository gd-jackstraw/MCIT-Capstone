# Repository housing Terraform code for the MCIT 2024 Capstone Cloud Computing project


This repo hosts the terraform code to deploy a storage backup solution to back up an existing firestore database in Google Cloud

The design is based off the following diagram - created by fellow classmate Husni:


![WhatsApp Image 2024-04-30 at 11 55 28_3d8be279](https://github.com/gd-jackstraw/MCIT-Capstone/assets/143850151/1124c35e-adbd-462e-b9b0-f73b30136264)



The Firestore DB exists already in the Google Cloud project. 

The code enables the required APIs and creates a storage bucket with a set name, location, access policy and retention policy. 

The code then creates a workflow with a scheduler to backup the entire Firestore DB into the created storage account on a set schedule. 
For demonstration purposes the schedule is every night at midnight but can be changed to suit frequency requirements.


The Cloud provider chosen is Google Cloud. There are steps required to set up the environments used to deploy this code.

The first step is to create a Project in Google Cloud to work in. We set up 3 projects - dev, qa and prod. 

All required GCP projects can be found here which can only be viewed if your account has been given the proper permissions.

https://console.cloud.google.com/welcome?hl=en&project=mcit-capstone-dev 
https://console.cloud.google.com/welcome?hl=en&project=mcit-capstone-qa 
https://console.cloud.google.com/welcome?hl=en&project=mcit-capstone-prod

Each project has a Service Account created specifically to authorize Terraform Cloud via an environment variable. You generate a key for each Service Account and use the following Cloudshell command to make it TF readable:

cat <project-id-randomstring.json> | tr -s '\n' ' ' 



New Terraform Cloud workspaces were created pulling code from the github repo main branch as the "prod" branch + dev and qa branches used for the project.


The output was then added to the associated HCP/Terraform cloud workspace as an Environment Variable tagged as "sensitive" - this environment variable is linked to the Service Account for the Google Cloud Project. The code uses this Service Account and its IAM binding roles to deploy the IAC.

In order to grant the necessary permissions for the Service Account, roles need to be added to the IAM binding. These are the roles I found were required in order to allow Terraform Cloud/HCP to deploy:

roles/workflows.invoker
roles/workflows.editor
roles/storage.objectCreator
roles/datastore.importExportAdmin
roles/servicemanagement.quotaViewer
roles/apigateway.admin
roles/workflows.serviceAgent
roles/firestore.serviceAgent
roles/compute.serviceAgent

They are added via Cloudshell with the following command:

gcloud projects add-iam-policy-binding \
<PROJECT_ID> \
 --member='serviceAccount:<SERVICE_ACCOUNT_EMAIL>' \
 --role='roles/<ROLE>'

 This may be more permissions than required. A review of permissions granted may be in order to minimize excess permissions.

 
