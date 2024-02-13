provider "google" {
  credentials = file("/Users/tominaked/Desktop/micasinotest/vaulted-cove-414218-caaa08f9a217.json")
  project     = "vaulted-cove-414218"
  region      = "europe-west9"
}

resource "google_compute_instance" "micasinovm" {
  boot_disk {
    auto_delete = true
    device_name = "micasinovm"

    initialize_params {
      image = "projects/rhel-cloud/global/images/rhel-7-v20240110"
      size  = 50
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-small"
  name         = "micasinovm"


  network_interface {
    network = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.main.id
    access_config {
      network_tier = "PREMIUM"
    }
    network_ip  = "10.0.0.2"
    queue_count = 0
    stack_type  = "IPV4_ONLY"

  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server", "lb-health-check"]
  zone = "europe-west9-a"
}
