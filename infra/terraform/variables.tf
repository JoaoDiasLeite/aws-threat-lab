variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "aws-threat-lab"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "threat-lab-key"
}

variable "alert_email" {
  description = "Email address to receive SNS alerts"
  type        = string
}

variable "enable_logging" {
  description = "Enable logging resources such as CloudTrail and CloudWatch log group"
  type        = bool
  default     = true
}

variable "enable_alerts" {
  description = "Enable SNS alerts and CloudWatch alarms"
  type        = bool
  default     = true
}

variable "host_log_retention_days" {
  description = "Retention in days for EC2 host log groups"
  type        = number
  default     = 7
}

variable "log_retention_days" {
  description = "Retention in days for S3 evidence logs"
  type        = number
  default     = 90
}

variable "enable_storage" {
  description = "Enable S3 evidence bucket with lifecycle rules"
  type        = bool
  default     = true
}

variable "enable_budget" {
  description = "Enable AWS budget with cost alerts"
  type        = bool
  default     = true
}

variable "budget_monthly_limit" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 10
}

variable "budget_alert_threshold" {
  description = "Percentage of budget to trigger alert (0-100)"
  type        = number
  default     = 80
}