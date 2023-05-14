/*
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.90.0"
    }
  }

}
*/

provider "yandex" {
  zone = var.zone
  //service_account_key_file = var.service_account_key_file
}

module "bastion" {
  service_account_key_file = var.service_account_key_file
  source                   = "../modules/bastion"
  public_key_path          = var.public_key_path
  bastion_disk_image       = var.bastion_disk_image
  subnet_id                = var.subnet_id
}

module "app" {
  service_account_key_file = var.service_account_key_file
  source                   = "../modules/app"
  public_key_path          = var.public_key_path
  app_disk_image           = var.app_disk_image
  subnet_id                = var.subnet_id
  depends_on               = [module.db] // Uncomment this line
  db_address               = module.db.internal_ip_address_db
  private_key_path         = var.private_key_path
}

module "db" {
  service_account_key_file = var.service_account_key_file
  source                   = "../modules/db"
  public_key_path          = var.public_key_path
  db_disk_image            = var.db_disk_image
  subnet_id                = var.subnet_id
  depends_on               = [module.bastion] // Uncomment this line
  bastion_host             = module.bastion.external_ip_address_bastion
  private_key_path         = var.private_key_path
}
