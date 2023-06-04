variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "app_disk_image" {
  description = "Disk image for Reddit app"
  default     = "reddit-app-base"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "db_address" {
  description = "Database IP address"
}
variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}
variable "disable_provisioning" {
  type = bool
  default = false
}
variable "env_type" {
  description = "Environmental type (prod, stage, etc)"
}
