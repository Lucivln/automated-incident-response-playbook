# aws/terraform/containment.tf (Updated)

# 1. Look up the existing target instance (Simplified filter)
data "aws_instance" "target_host_lookup" {
  filter {
    name   = "tag:Name"
    values = ["Wazuh-Target"] # VERIFY THIS IS EXACTLY THE TAG IN AWS!
  }
  # DELETE this line: instance_state_names = ["running"]
}

# 2. Use the instance attachment resource... (rest of the code remains)
resource "aws_instance_sg_attachment" "quarantine_attachment" {
  instance_id        = data.aws_instance.target_host_lookup.id
  security_group_id  = aws_security_group.quarantine_sg.id
}
