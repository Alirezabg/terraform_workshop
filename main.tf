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
resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8000", "5001", "5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}
resource "google_compute_network" "default" {
  name = "my-network"
}
resource "google_compute_subnetwork" "default" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.default.id
}
resource "google_compute_instance" "virtual_instance" {
  name         = "api-one-terra"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

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

  tags = ["http-server", "https-server", "web"]

}
resource "google_compute_instance" "virtual_instance2" {
  name         = "api-two-terra"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = file("vm2_startup_script.sh")

  tags = ["http-server", "https-server", "web"]

}
resource "google_compute_instance" "virtual_instance3" {
  name         = "api-three-terra"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = file("vm3_startup_script.sh")

  tags = ["http-server", "https-server", "web"]

}
