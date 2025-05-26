packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}
####veera

variable "aws_region" {
  type    = string
  default = "ap-south-2"
}

source "amazon-ebs" "ubuntu-node" {
  region           = var.aws_region
  source_ami         = "ami-053a0835435bf4f45"
  instance_type    = "t3.medium"
  ami_name         = "node-app-ami-{{timestamp}}"
  ssh_username     = "ubuntu"



build {
  name    = "build-node-app-ami"
  sources = ["source.amazon-ebs.ubuntu-node"]

  provisioner "file" {
    # Copy the entire app directory as /tmp/node-app on remote
    source      = "app"
    destination = "/tmp/node-app"
  }

  provisioner "file" {
    source      = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }
####veera
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }
}
