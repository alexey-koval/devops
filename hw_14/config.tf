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
  profile = "default"
}

#AWS Instance BuildServer
resource "aws_instance" "BuildServer" {
  ami = ami-05f7491af5eef733a
  instance_type = "t2.micro"
  key_name = "mykeys"
  security_groups = ["MSG"]
  subnet_id = "subnet-e96ebeb6"
  user_data = <<EOF
          #!/bin/bash
          sudo apt update && sudo apt install -y maven default-jdk git awscli
          git clone https://github.com/alexey-koval/boxfuse-origin /home/ubuntu/
          cd /home/ubuntu/boxfuse-origin/
          mvn package
          EOF
  provisioner "remote-exec" {
    inline = ["export AWS_ACCESS_KEY_ID=<...placeholder...>", "export AWS_SECRET_ACCESS_KEY=<...placeholder...>",
              "export AWS_DEFAULT_REGION=us-east-1",
              "aws s3 cp home/ubuntu/boxfuse-origin/target/*.war s3://mybucket.test.com/hello.war"
             ]
        }
    }

#AWS Instance Production
resource "aws_instance" "Production" {
  ami = ami-05f7491af5eef733a
  instance_type = "t2.micro"
  key_name = "mykeys"
  security_groups = ["MSG"]
  subnet_id = "subnet-e96ebeb6"
  user_data = <<EOF
          #!/bin/bash
          sudo apt update
          sudo apt install tomcat -y
          sudo apt install awscli -y
          EOF
  provisioner "remote-exec" {
    inline = ["export AWS_ACCESS_KEY_ID=<...placeholder...>", "export AWS_SECRET_ACCESS_KEY=<...placeholder...>",
              "export AWS_DEFAULT_REGION=us-east-1",
              "aws s3 cp s3://mybucket.test.com/hello.war /usr/local/tomcat/webapps/hello.war",
              "sudo systemctl restart tomcat9"
             ]
  }
}
