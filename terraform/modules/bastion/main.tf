
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.90.0"
    }
  }
}

resource "yandex_compute_instance" "bastion" {
  name = "bastion-host"
  platform_id = "standard-v2"
  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = var.bastion_disk_image
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  scheduling_policy {
    preemptible = true
  }
  allow_stopping_for_update = true
}
