terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.93.0"
    }
  }

}


provider "yandex" {
  zone = var.zone
  //service_account_key_file = var.service_account_key_file
}

resource "yandex_compute_instance" "gitlab" {
  name        = "gitlab-ci-vm"
  platform_id = "standard-v2"
  resources {
    cores  = 2
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = var.disk_image
      size     = 50
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  allow_stopping_for_update = true



  provisioner "local-exec" {
    command = "sleep 30 && ansible-playbook playbook.yml"
  }


  labels = {
    label       = "gitlab"
    machinetype = "gitlab"
  }
}
