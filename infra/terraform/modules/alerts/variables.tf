variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "alert_email" {
  type = string
}

variable "cloudwatch_log_group" {
  type = string
}

variable "auth_log_group" {
  type = string
}

variable "nginx_error_log_group" {
  type = string
}
