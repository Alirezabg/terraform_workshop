##################
# CONFIGURATION
##################

locals {
  project_id = "titanium-acumen-367712"
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.0"
    }
  }
}


provider "google" {
  project     = local.project_id
  region      = "us-central1"
  zone        = "us-central1-c"
  credentials = file("terra.json")
}
resource "google_project_service" "project" {
  service = "compute.googleapis.com"
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "google_compute_instance" "virtual_instance" {
  name         = "api-one-terra"
  machine_type = "f1-micro"
  zone         = "us-east1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = file("vm_startup_scrip.sh")

}
