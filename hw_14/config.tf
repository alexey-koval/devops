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
  security_groups = ["MSG"]
  availability_zone = "var.availability_zone"
  provisioner "remote-exec" {
    inline = ["apt update && apt install -y maven default-jdk git",
              "git clone https://github.com/alexey-koval/boxfuse-origin /home/ubuntu/",
              "cd /home/ubuntu/boxfuse-origin/",
              "mvn package"
    ]
  }
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
  security_groups = ["MSG"]
  availability_zone = "var.availability_zone"
  provisioner "remote-exec" {
    inline = ["apt update", "apt install tomcat"
    ]
}
  provisioner "remote-exec" {
    inline = ["export AWS_ACCESS_KEY_ID=<...placeholder...>", "export AWS_SECRET_ACCESS_KEY=<...placeholder...>",
              "export AWS_DEFAULT_REGION=us-east-1",
              "cd /usr/local/tomcat/webapps/",
              "aws s3 cp s3://mybucket.test.com/hello.war hello.war"
    ]
  }
}