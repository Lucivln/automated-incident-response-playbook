# aws/terraform/containment.tf (Final Correct Content)

# This resource directly applies the quarantine SG to the specific instance.
resource "aws_instance_sg_attachment" "quarantine_attachment" {
  instance_id        = "i-07a63ccf7a8e94489"
  security_group_id  = aws_security_group.quarantine_sg.id
}
