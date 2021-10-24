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

#AWS Instance BuildServer
resource "aws_instance" "BuildServer" {
  ami = ami-05f7491af5eef733a
  instance_type = "t2.micro"
  availability_zone = "var.availability_zone"
  provisioner "remote-exec" {
    inline = ["apt update", "apt install maven",
              "apt install default-jdk",
              "apt install git",
              "cd /home/ubuntu/", "git clone https://github.com/alexey-koval/boxfuse-origin",
              "cd /home/ubuntu/boxfuse-origin/",
              "mvn package"
    ]
  }
  provisioner "file" {
    source = "/home/ubuntu/boxfuse-origin/target/*.war"
    destination = "s3:mybucket.test.com/hello.war"
}
  }

#AWS Instance Production
resource "aws_instance" "Production" {
  ami = ami-05f7491af5eef733a
  instance_type = "t2.micro"
  availability_zone = "var.availability_zone"
  provisioner "remote-exec" {
    inline = ["apt update", "apt install tomcat9"
    ]
}
  provisioner "file" {
    source = "s3:mybucket.test.com/hello.war"
    destination = "/usr/local/tomcat/webapps/"
  }
}