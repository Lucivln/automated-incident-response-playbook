# aws/terraform/containment.tf (New data source)

# 1. Look up the existing target instance (Using Instance ID directly)
resource "null_resource" "quarantine_target" {}

variable "target_instance_id" {
  description = "ID of the instance to quarantine"
  default     = "i-07a63ccf7a8e94489" # REPLACE THIS
}

# 2. Use the instance attachment resource for containment
resource "aws_instance_sg_attachment" "quarantine_attachment" {
  instance_id        = var.target_instance_id
  security_group_id  = aws_security_group.quarantine_sg.id
}
