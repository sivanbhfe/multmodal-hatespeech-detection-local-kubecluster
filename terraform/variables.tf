variable "key_name" {
  description = "EC2 SSH key pair name"
  type        = string
}

variable "private_key_path" {
  description = "Location of pem file for Terraform to access"
  type        = string
}