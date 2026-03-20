variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "retention_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 90
}

variable "archive_days" {
  type        = number
  description = "Number of days before archiving to Glacier"
  default     = 30
}
