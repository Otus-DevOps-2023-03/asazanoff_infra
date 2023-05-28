output "external_ip_address_app" {
  value = module.app.external_ip_address_app
}
output "external_ip_address_bastion" {
  value = module.bastion.external_ip_address_bastion
}
output "internal_ip_address_db" {
  value = module.db.internal_ip_address_db
}
