variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "db_disk_image" {
  description = "Database image for Reddit app"
  default     = "reddit-db-base"
}
variable "bastion_host" {
  description = "Bastion host IP Address"
}
variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}
variable "env_type" {
  description = "Environmental type (prod, stage, etc)"
}
