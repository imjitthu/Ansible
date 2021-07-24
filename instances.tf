provider "aws" {
  region = "${var.REGION}"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-rs-practice"
    key    = "rs-instances/ansible.tfstate"
    region = "us-east-1"
  }
}

#Centos-7-DevOps-Practice - ami-059e6ca6474628ef0

data "aws_ami" "AMI" {
    most_recent = true
    owners = ["973714476881"]
    filter {
        name = "name"
        values = ["Centos-7-DevOps-Practice"]
    }
}

resource "aws_instance" "instance" {
  count   = length(var.COMPONENT)
  ami = "${data.aws_ami.AMI.id}"
  instance_type = "${var.INSTANCE_TYPE}"
  user_data = "set hostname ${element(var.COMPONENT, count.index)}"
  tags = {
    Name = "${element(var.COMPONENT, count.index)}-${var.ENV}"
  }
}