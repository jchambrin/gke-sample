# README

First, you need to configure the PROJECT_ID environment variable e.g. `export PROJECT_ID=ricardo-gke-sample-1`

## Create the project
After creating your project, you will need to associate a billing account.
```bash
gcloud projects create ${PROJECT_ID}
gcloud config set project ${PROJECT_ID}
```

## Enable GCP APIs
```bash
gcloud services enable \
  container.googleapis.com
```

## Create the terraform bucket
```bash
gsutil mb gs://terraform-${PROJECT_ID}
```

## Terraform configuration

### Create the Terraform service account
Create terraform service account
```bash
gcloud iam service-accounts create sa-terraform --display-name "Terraform service account"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/container.admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/compute.admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountAdmin"
  gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"
```

Export the key file
```bash
gcloud iam service-accounts keys create ./key.json --iam-account sa-terraform@${PROJECT_ID}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS=$PWD/key.json
```

### Terraform commands

Go to terraform folder by doing `cd terraform`

```bash
terraform init
```

Modify the terraform.tfvars file to specify your parameters

To verify which resources will be created
```bash
terraform plan
```

To launch the creation
```bash
terraform apply
```

## Kubernetes
Fetch the cluster credentials. The following command will update your kube config file (~/.kube/config)
```bash
gcloud container clusters get-credentials ${PROJECT_ID}-gke --region="europe-west1"
```

Install the k8s manifests
```bash
kubectl apply -f k8s/ -R
```

Wait for the load balancer to be provisionned. The following command should return the IP once it is done
```bash
kubectl get ingress
```

You can then access the Hello World in your browser or with curl for example:
```bash
curl http://${IP}
```