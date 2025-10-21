# aws/terraform/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "project-key"
  public_key = file("/root/.ssh/id_rsa.pub")
}

# Provision the EC2 instance for the security incident target
resource "aws_instance" "target_host" {
  ami           = "ami-0a716d3f3b16d290c" # Ubuntu 20.04 AMI, verify for your region
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "Wazuh-Target"
  }
}

# Provision the EC2 instance to host the Wazuh server
resource "aws_instance" "wazuh_server" {
  ami           = "ami-0a716d3f3b16d290c" # Ubuntu 20.04 AMI, verify for your region
  instance_type = "t3.micro" # Recommended t2.medium for Wazuh
  key_name      = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "Wazuh-Server"
  }
}
