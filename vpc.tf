provider "google" {
  credentials = file("/Users/tominaked/Desktop/micasinotest/vaulted-cove-414218-caaa08f9a217.json")
  project     = "vaulted-cove-414218"
  region      = "europe-west9"
}

# Crear la VPC
resource "google_compute_network" "main" {
  name                    = "main-network"
  auto_create_subnetworks = false
}

# Crear la subnet
resource "google_compute_subnetwork" "main" {
  name          = "main-subnet"
  region        = "europe-west9"
  network       = google_compute_network.main.id
  ip_cidr_range = "10.0.0.0/16"
}

# Crear reglas de firewall
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "allow-https"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-postgres" {
  name    = "allow-postgres"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
}
