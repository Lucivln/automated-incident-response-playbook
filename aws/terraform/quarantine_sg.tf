# aws/terraform/quarantine_sg.tf

# Data source to retrieve the VPC ID (assuming it's already created by main.tf)
data "aws_vpc" "default" {
  default = true
}

# 1. Define the Quarantine Security Group (Blocks everything by default)
resource "aws_security_group" "quarantine_sg" {
  name        = "Wazuh-Quarantine-SG"
  description = "Quarantine group: Blocks all traffic except manager communication."
  vpc_id      = data.aws_vpc.default.id

  # Ingress Rule: Absolutely NO INBOUND TRAFFIC is allowed.
  # By omitting an ingress block, the default is to deny all incoming traffic.

  # Egress Rule: Allow ONLY UDP traffic back to the Wazuh Manager (Port 1514).
  # The instance needs to send status/logs even while quarantined.
  egress {
    description = "Allow Wazuh Agent outbound to Manager (UDP 1514)"
    from_port   = 1514
    to_port     = 1514
    protocol    = "udp"
    # NOTE: You'll need to update this CIDR block to the private IP of your Wazuh-Server.
    # For now, we'll use a placeholder or assume the private IP is defined elsewhere.
    # We'll rely on the main.tf or containment.tf to pass the correct private IP.
    # For simplicity, we'll reference the server instance if it's in the same main.tf:
    # However, since the server instance is likely defined in main.tf, we'll need to fetch its IP.
    cidr_blocks = ["172.31.0.0/16"] # Adjust this to the specific private IP of the Wazuh-Server later
  }

  tags = {
    Name = "Wazuh-Quarantine-SG"
  }
}
