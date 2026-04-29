terraform {
  backend "s3" {
    bucket         = "odehgreg-tfstate-euw1-1777482285"
    key            = "capstone-eu-west-1/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-euw1"
    encrypt        = true
  }
}