# aws/terraform/containment.tf

# 1. Look up the existing target instance by its Name tag
data "aws_instance" "target_host_lookup" {
  filter {
    name   = "tag:Name"
    values = ["Wazuh-Target"] # Uses the name set in main.tf
  }
  instance_state_names = ["running"]
}

# 2. Resource to update the security group attachment
# This is the resource that the GitHub Actions job will create/modify.
# It detaches the old SG (the default) and attaches the new quarantine_sg.
resource "aws_network_interface_sg_attachment" "quarantine_attachment" {
  # The target is the first network interface of the looked-up instance
  network_interface_id = data.aws_instance.target_host_lookup.network_interface_id

  # The Security Group to attach is the restrictive Quarantine SG
  security_group_id    = aws_security_group.quarantine_sg.id
}
