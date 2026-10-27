output "sns_topic_arn" {
  value = aws_sns_topic.security_alerts.arn
}

output "sns_topic_name" {
  value = aws_sns_topic.security_alerts.name
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.security_overview.dashboard_name
}
