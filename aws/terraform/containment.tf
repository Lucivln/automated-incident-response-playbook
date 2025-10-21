# aws/terraform/containment.tf (Ensure this is the final, correct content)

# 1. Look up the existing target instance
data "aws_instance" "target_host_lookup" {
  filter {
    name   = "tag:Name"
    values = ["Wazuh-Target"] 
  }
  instance_state_names = ["running"]
  # NOTE: If this fails, the host might not be fully "running" when the job starts.
}

# 2. Use the instance attachment resource for reliable containment
resource "aws_instance_sg_attachment" "quarantine_attachment" {
  # Use the simple instance ID from the lookup
  instance_id        = data.aws_instance.target_host_lookup.id
  # Use the ID of the Quarantine Security Group
  security_group_id  = aws_security_group.quarantine_sg.id
}
