# aws/terraform/containment.tf (Final Clean Content)

# This resource directly applies the quarantine SG to the specific instance.
resource "aws_instance_sg_attachment" "quarantine_attachment" {
  # CRITICAL: REPLACE "i-xxxxxxxxxxxxxxxxx" with your actual Wazuh-Target Instance ID.
  instance_id        = "i-07a63ccf7a8e94489" 
  security_group_id  = aws_security_group.quarantine_sg.id
}

# 2. Use the instance attachment resource for containment
resource "aws_instance_sg_attachment" "quarantine_attachment" {
  instance_id        = var.target_instance_id
  security_group_id  = aws_security_group.quarantine_sg.id
}
