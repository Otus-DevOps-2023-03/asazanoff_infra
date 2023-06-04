variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "bastion_disk_image" {
  description = "Bastion host image"
}
variable "env_type" {
  description = "Environmental type (prod, stage, etc)"
}
