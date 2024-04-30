# Repository housing Terraform code for the MCIT 2024 Capstone Cloud Computing project


This repo hosts the terraform code to deploy a storage backup solution to back up an existing firestore database in Google Cloud

The design is based off the following diagram - created by fellow classmate Husni:


![WhatsApp Image 2024-04-30 at 11 55 28_3d8be279](https://github.com/gd-jackstraw/MCIT-Capstone/assets/143850151/1124c35e-adbd-462e-b9b0-f73b30136264)



The Firestore DB exists already in the Google Cloud project. 

The code enables the required APIs and creates a storage bucket with a set name, location, access policy and retention policy. 

The code then creates a workflow with a scheduler to backup the entire Firestore DB into the created storage account on a set schedule. 
For demonstration purposes the schedule is every night at midnight but can be changed to suit frequency requirements.
