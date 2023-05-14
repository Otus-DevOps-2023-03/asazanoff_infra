
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.90.0"
    }
  }
}


resource "yandex_compute_instance" "db" {
  name        = "reddit-db"
  platform_id = "standard-v2"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = false
  }
  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  scheduling_policy {
    preemptible = true
  }
  allow_stopping_for_update = true

  connection {
    type        = "ssh"
    host        = self.network_interface.0.ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)

    bastion_host        = var.bastion_host
    bastion_private_key = file(var.private_key_path)
    bastion_user        = "ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf",
      "sudo systemctl restart mongod"
    ]
  }

}
