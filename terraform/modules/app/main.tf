
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.90.0"
    }
  }
}


resource "yandex_compute_instance" "app" {
  name        = "${var.env_type}-reddit-app"
  platform_id = "standard-v2"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
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

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }
  /*
  provisioner "file" {

    content = templatefile("${path.module}/puma.service", {
      "database_url" = var.db_address
    })

    //^^^ uncomment this and comment next line
    //source      = "puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "${path.module}/deploy.sh"
  }
  */
  labels = {
    label            = "app"
    machinetype      = "appserver"
    environment_type = var.env_type
  }
}
