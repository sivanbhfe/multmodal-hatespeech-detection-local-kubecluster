terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "k3s/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
