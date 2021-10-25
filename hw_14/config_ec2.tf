#AWS Provider connect
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_key_pair" "devops" {
  key_name   = "devops"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC59IWdQHx4Shc7R5I9AD4Vf1aqxVzsJsdpzpNrKfIii27+hgKYQr+MLZpN+HSrjErz9Pt0fU0gqxooFGpqK02wx5peVw6Yrn+CxP12yOTyohBnNm5F4tUQW9hurwrMR1R5 devops"
}

resource "aws_instance" "TEST" {
  ami = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  key_name = "devops"
  security_groups = ["MSG"]
  subnet_id = "subnet-694bd825"
}
