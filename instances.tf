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
    Name = "${element(var.COMPONENT, count.index)}"  
    # Name = "${element(var.COMPONENT, count.index)}-${var.ENV}"
  }
}

resource "null_resource" "make_inv_file" {
  count   = length(aws_instance.instance)
  provisioner "local-exec" {
    command = "sh mkinv.sh"
    #command = "echo ${element(aws_instance.instance, count.index).private_ip} component=${element(var.COMPONENT, count.index)} >> /tmp/inv.txt"
    #command = "sed -i s/env/${var.ENV}/g inv.sh"
  }
}

data "aws_route53_zone" "jithendar" {
  name = "jithendar.com"
  private_zone = false
}

resource "aws_route53_record" "roboshop" {
  count = length(var.COMPONENT)
  allow_overwrite = true
  name       = "${element(var.COMPONENT, count.index)}.${data.aws_route53_zone.jithendar.name}"
  zone_id    = "${data.aws_route53_zone.jithendar.zone_id}"
  type       = "A"
  ttl        = "300"
  records    = ["${element(aws_instance.instance, count.index)}".private_ip]
}