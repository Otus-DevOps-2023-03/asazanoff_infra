variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "disk_image" {
  description = "Ubuntu disk image"
  default     = "fd8ebb4u1u8mc6fheog1"
}
variable "service_account_key_file" {
  description = "key .json"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}
