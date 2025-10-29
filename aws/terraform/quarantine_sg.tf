# aws/terraform/quarantine_sg.tf - FIXED DUPLICATE AND IMPROVED EGRESS

# The data "aws_vpc" "default" block was removed here to fix the error.
# It is now referenced from main.tf.

# 1. Define the Quarantine Security Group
resource "aws_security_group" "quarantine_sg" {
  name        = "Wazuh-Quarantine-SG"
  description = "Quarantine group: Blocks all traffic except manager communication."
  # Reference the VPC ID from the block in main.tf
  vpc_id      = data.aws_vpc.default.id

  # Ingress Rule: Omitted - denies all inbound traffic by default.

  # Egress Rule: Allow ONLY UDP traffic back to the Wazuh Manager (Port 1514).
  egress {
    description = "Allow Wazuh Agent outbound to Manager (UDP 1514)"
    from_port   = 1514
    to_port     = 1514
    protocol    = "udp"
    # Dynamically reference the private IP of the Wazuh Server
    cidr_blocks = ["${aws_instance.wazuh_server.private_ip}/32"]
  }

  tags = {
    Name = "Wazuh-Quarantine-SG"
  }
}
