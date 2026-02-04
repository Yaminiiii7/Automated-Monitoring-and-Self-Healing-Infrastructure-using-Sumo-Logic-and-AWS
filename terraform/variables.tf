variable "alert_email" {
  description = "Email address to receive SNS alerts"
  type        = string
}

variable "region" {
  description = "region of aws resources"
  type = string
}

variable "aws_account_no" {
  description = "AWS Account Number"
  type = string
}