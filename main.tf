##################
# CONFIGURATION
##################
variable "project_id" {
    type = string
}

locals {
  project_id = var.project_id
}
provider "google" {
  version = "3.5.0"
  project     = local.project_id
  region      = "us-central1"
  zone = "us-central1-c"
}
resource "google_project_service" "compute_service" {
  project = local.project_id
  service = "compute.googleapis.com"
}
resource "google_compute_network" "vpc_network" {
  name = "terraform-network-cyf"
  auto_create_subnetworks = false
  delete_default_routes_on_create = true
    depends_on = [
    google_project_service.compute_service
  ]
}
resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}
resource "google_compute_instance" "vm_instance" {
name = "api-1"
machine_type = "f1-micro"
zone = "us-central1-c"
tags         = ["ssh"]
boot_disk {
initialize_params {
image = "debian-cloud/debian-11"
}
}
resource "google_compute_instance" "vm_instance" {
name = "tapi-2"
machine_type = "f1-micro"
zone = "us-central1-c"
  tags         = ["ssh"]
boot_disk {
initialize_params {
image = "debian-cloud/debian-11"
}
}
resource "google_compute_instance" "vm_instance" {
name = "flask-app"
machine_type = "f1-micro"
zone = "us-central1-c"
tags = ["ssh"]
boot_disk {
initialize_params {
image = "debian-cloud/debian-11"
}
}
metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

network_interface {
network = google_compute_network.vpc_network.name
access_config {
}
}
}
resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}
# [START cloudloadbalancing_regional_health_check]
resource "google_compute_region_health_check" "default" {
  name               = "tcp-health-check"
  timeout_sec        = 5
  check_interval_sec = 5
  tcp_health_check {
    port = "80"
  }
  region = "us-central1"
}