resource "aws_budgets_budget" "threat_lab" {
  name              = "${var.project_name}-${var.environment}-monthly"
  budget_type       = "MONTHLY"
  limit_unit        = "USD"
  limit_amount      = var.monthly_limit
  time_period_start = "2024-01-01_00:00"
  time_period_end   = "2087-06-15_00:00"

  tags = {
    Name        = "${var.project_name}-${var.environment}-budget"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_budgets_budget_notification" "threat_lab" {
  budget_name       = aws_budgets_budget.threat_lab.name
  comparison_operator = "GREATER_THAN"
  notification_type = "ACTUAL"
  threshold         = var.alert_threshold
  threshold_type    = "PERCENTAGE"

  subscriber_email_addresses = [var.alert_email]
}

resource "aws_budgets_budget_notification" "threat_lab_forecast" {
  budget_name       = aws_budgets_budget.threat_lab.name
  comparison_operator = "GREATER_THAN"
  notification_type = "FORECASTED"
  threshold         = var.alert_threshold
  threshold_type    = "PERCENTAGE"

  subscriber_email_addresses = [var.alert_email]
}
