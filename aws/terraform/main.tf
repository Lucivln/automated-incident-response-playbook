# aws/terraform/main.tf

# 1. AWS Provider Configuration (Implicitly used from versions.tf)
provider "aws" {
  region = "eu-north-1"
}

# 2. VPC Data Source (To get default Security Group ID for instances)
data "aws_vpc" "default" {
  default = true
}

# 3. Provision SSH Key Pair
resource "aws_key_pair" "ssh_key" {
  key_name   = "project-key"
  public_key = file("/root/.ssh/id_rsa.pub") # Use absolute path
}

# 4. Provision the Wazuh Server EC2 Instance
resource "aws_instance" "wazuh_server" {
  ami           = "ami-0b0d611b854e4f738" # REPLACE with your actual EU-NORTH-1 AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  # Explicitly assign default SG to avoid conflict with containment.tf
  vpc_security_group_ids = [data.aws_vpc.default.default_security_group_id]
  tags = {
    Name = "Wazuh-Server"
  }
}

# 5. Provision the Wazuh Target EC2 Instance
resource "aws_instance" "target_host" {
  ami           = "ami-0b0d611b854e4f738" # REPLACE with your actual EU-NORTH-1 AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  # Explicitly assign default SG to avoid conflict with containment.tf
  vpc_security_group_ids = [data.aws_vpc.default.default_security_group_id]
  tags = {
    Name = "Wazuh-Target"
  }
}
