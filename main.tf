provider "google" {
  credentials = file("/Users/tominaked/Desktop/micasinotest/ultra-concord-413810-ddfeffef90cb.json")
  project     = "ultra-concord-413810"
  region      = "europe-west4-a"
}

resource "google_sql_database_instance" "micasinodb" {
  name             = "micasinodb"
  database_version = "POSTGRES_15"
  region           = "europe-west4-a"
  
  settings {
    tier             = "db-f1-micro"
    user_labels = {
      max_connections = "500"
    }
  }
}

resource "google_sql_user" "micasino_admin" {
  name     = "micasino_admin"
  instance = google_sql_database_instance.micasinodb.name
  password = random_id.password.hex
}

resource "google_compute_instance" "micasino_vm" {
  name         = "micasino-vm"
  machine_type = "e2-small"
  zone         = "europe-west4-a"

  boot_disk {
    initialize_params {
      image = "your-image"
    }
  }

  network_interface {
    network = google_compute_network.micasino_network.self_link
    subnetwork = google_compute_subnetwork.micasino_subnet.self_link
  }
}

resource "random_id" "password" {
  byte_length = 12
}

resource "google_compute_network" "micasino_network" {
  name = "micasino-network"
}

resource "google_compute_subnetwork" "micasino_subnet" {
  name          = "micasino-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.micasino_network.self_link
  region        = "europe-west4"
}
