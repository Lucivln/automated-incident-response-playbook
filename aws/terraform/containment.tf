# aws/terraform/containment.tf (Replace existing content)

# 1. Look up the existing target instance
data "aws_instance" "target_host_lookup" {
  filter {
    name   = "tag:Name"
    values = ["Wazuh-Target"]
  }
  instance_state_names = ["running"]
}

# 2. Use the instance attachment resource for containment
# This is a simpler and more reliable resource for attaching a single SG.
resource "aws_instance_sg_attachment" "quarantine_attachment" {
  instance_id        = data.aws_instance.target_host_lookup.id
  security_group_id  = aws_security_group.quarantine_sg.id
}
