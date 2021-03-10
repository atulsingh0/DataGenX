# Enabling GCP VM to access Google APIs

# All APIs access
gcloud compute instances create vm-full \
--zone us-east1-b \
--machine-type=e2-micro \
--scopes cloud-platform \
--boot-disk-size=20GB \
--preemptible

gcloud compute ssh vm-full



# Read-Wrote Compute Engine Access
gcloud compute instances create vm-compute \
--zone us-east1-b \
--machine-type=e2-micro \
--scopes compute \
--boot-disk-size=20GB \
--preemptible

gcloud compute ssh vm-compute



# DataStote,PubSub, Cloud Storage
gcloud compute instances create vm-other \
--zone us-east1-b \
--machine-type=e2-micro \
--scopes datastore,pubsub,storage-full \
--boot-disk-size=20GB \
--preemptible

gcloud compute ssh vm-other

