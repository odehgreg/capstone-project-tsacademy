terraform {
  backend "s3" {
    bucket         = "novara-terraform-state-odeh-james-euw1"
    key            = "capstone-eu-west-1/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-euw1"
  }
}