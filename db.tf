provider "google" {
  credentials = file("/Users/tominaked/Desktop/micasinotest/vaulted-cove-414218-caaa08f9a217.json")
  project     = "vaulted-cove-414218"
  region      = "europe-west9"
}

resource "google_sql_database_instance" "micasinodb" {
  name             = "micasinodb"
  database_version = "POSTGRES_15"
  region           = "europe-west9"
  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.main.self_link
      subnet          = google_compute_subnetwork.main.self_link
    }

    database_flags {
      name  = "max_connections"
      value = "500"
    }
  }
}

resource "google_sql_user" "micasino_read" {
  instance    = google_sql_database_instance.micasinodb.name
  name        = "micasino_read"
  password    = random_password.password.result
  depends_on  = [google_sql_database_instance.micasinodb]
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "google_sql_database_instance" "micasinodb_replica" {
  name                 = "micasinodb-replica"
  master_instance_name = google_sql_database_instance.micasinodb.name
  region               = "europe-west9"
  database_version     = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"
  }
}

