variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "alert_email" {
  type        = string
  description = "Email for budget alerts"
}

variable "monthly_limit" {
  type        = number
  description = "Monthly budget limit in USD"
  default     = 10
}

variable "alert_threshold" {
  type        = number
  description = "Percentage of budget to trigger alert (0-100)"
  default     = 80
}
