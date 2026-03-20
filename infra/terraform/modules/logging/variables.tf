variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "ec2_role_name" {
  type = string
}

variable "trail_name" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "host_log_retention_days" {
  type    = number
  default = 7
}