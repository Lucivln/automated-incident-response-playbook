# aws/terraform/main.tf - CORRECTED

# 1. AWS Provider Configuration
provider "aws" {
  region = "eu-north-1"
}

# 2. VPC Data Source (Source of truth for default VPC)
data "aws_vpc" "default" {
  default = true
}

# 2B. Fetch the default Security Group ID (Place it HERE)
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# 3. Generate and Provision SSH Key Pair

# A. Generate the private key locally using the TLS provider
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# B. Upload the PUBLIC key to AWS
resource "aws_key_pair" "ssh_key" {
  key_name   = "project-key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# C. Save the PRIVATE key (.pem file) to the local directory
#    This uses a 'local-exec' provisioner to run a shell command.
resource "null_resource" "save_private_key" {
  # This block ensures the command only runs after the key is generated
  # and AWS is ready to use it.
  triggers = {
    key_pem = tls_private_key.key_pair.private_key_pem
  }

  # Execute a shell command to write the private key content to a file.
  provisioner "local-exec" {
    command = <<-EOT
      echo "${tls_private_key.key_pair.private_key_pem}" > ./project-key.pem
      chmod 400 ./project-key.pem
    EOT
    # Only run this on creation, not subsequent updates
    when = create
  }
}

# 4. Provision the Wazuh Server EC2 Instance
resource "aws_instance" "wazuh_server" {
  ami           = "ami-0854d4f8e4bd6b834" # REPLACE with your actual EU-NORTH-1 AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  # Assign default SG; it will be overwritten or supplemented by Ansible
  vpc_security_group_ids = [data.aws_security_group.default.id]
  
  tags = {
    Name = "Wazuh-Server"
  }
}

# 5. Provision the Wazuh Target EC2 Instance
resource "aws_instance" "target_host" {
  ami           = "ami-0854d4f8e4bd6b834" # REPLACE with your actual EU-NORTH-1 AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  # Assign default SG
  vpc_security_group_ids = [data.aws_security_group.default.id]
  
  tags = {
    Name = "Wazuh-Target"
  }
}

# 6. Outputs for use by other tools (e.g., Ansible)
output "wazuh_server_ip" {
  value = aws_instance.wazuh_server.public_ip
}

output "target_host_id" {
  value = aws_instance.target_host.id
}
