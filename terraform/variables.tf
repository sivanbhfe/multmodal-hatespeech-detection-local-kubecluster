variable "key_name" {
  description = "EC2 SSH key pair name"
  type        = string
}

variable "private_key_content" {
  description = "Passing pem file as content for Terraform to access"
  type        = string
  sensitive   = true
}