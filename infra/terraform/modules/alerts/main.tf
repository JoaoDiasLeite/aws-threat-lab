resource "aws_sns_topic" "security_alerts" {
  name = "${var.project_name}-${var.environment}-security-alerts"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Root account usage
resource "aws_cloudwatch_log_metric_filter" "root_usage" {
  name           = "${var.project_name}-${var.environment}-root-usage"
  log_group_name = var.cloudwatch_log_group
  pattern        = "{ $.userIdentity.type = Root && $.eventType != AwsServiceEvent }"

  metric_transformation {
    name      = "RootAccountUsageCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_usage_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-root-usage-alarm"
  alarm_description   = "Alarm for AWS root account usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RootAccountUsageCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

# Console login failures
resource "aws_cloudwatch_log_metric_filter" "console_login_failure" {
  name           = "${var.project_name}-${var.environment}-console-login-failure"
  log_group_name = var.cloudwatch_log_group
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"

  metric_transformation {
    name      = "ConsoleLoginFailureCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_login_failure_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-console-login-failure-alarm"
  alarm_description   = "Alarm for failed AWS console logins"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsoleLoginFailureCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

# IAM policy changes
resource "aws_cloudwatch_log_metric_filter" "iam_policy_changes" {
  name           = "${var.project_name}-${var.environment}-iam-policy-changes"
  log_group_name = var.cloudwatch_log_group
  pattern        = "{ ($.eventSource = iam.amazonaws.com) && (($.eventName = DeleteGroupPolicy) || ($.eventName = DeleteRolePolicy) || ($.eventName = DeleteUserPolicy) || ($.eventName = PutGroupPolicy) || ($.eventName = PutRolePolicy) || ($.eventName = PutUserPolicy) || ($.eventName = CreatePolicy) || ($.eventName = DeletePolicy) || ($.eventName = CreatePolicyVersion) || ($.eventName = DeletePolicyVersion) || ($.eventName = AttachRolePolicy) || ($.eventName = DetachRolePolicy) || ($.eventName = AttachUserPolicy) || ($.eventName = DetachUserPolicy) || ($.eventName = AttachGroupPolicy) || ($.eventName = DetachGroupPolicy)) }"

  metric_transformation {
    name      = "IAMPolicyChangeCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_policy_changes_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-iam-policy-changes-alarm"
  alarm_description   = "Alarm for IAM policy changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "IAMPolicyChangeCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

# Security group changes
resource "aws_cloudwatch_log_metric_filter" "security_group_changes" {
  name           = "${var.project_name}-${var.environment}-security-group-changes"
  log_group_name = var.cloudwatch_log_group
  pattern        = "{ ($.eventSource = ec2.amazonaws.com) && (($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)) }"

  metric_transformation {
    name      = "SecurityGroupChangeCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_group_changes_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-security-group-changes-alarm"
  alarm_description   = "Alarm for security group changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "SecurityGroupChangeCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

# New access key creation
resource "aws_cloudwatch_log_metric_filter" "new_access_key" {
  name           = "${var.project_name}-${var.environment}-new-access-key"
  log_group_name = var.cloudwatch_log_group
  pattern        = "{ ($.eventSource = iam.amazonaws.com) && ($.eventName = CreateAccessKey) }"

  metric_transformation {
    name      = "NewAccessKeyCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "new_access_key_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-new-access-key-alarm"
  alarm_description   = "Alarm for creation of new IAM access keys"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "NewAccessKeyCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

# SSH brute force attempts from auth.log
resource "aws_cloudwatch_log_metric_filter" "ssh_brute_force" {
  name           = "${var.project_name}-${var.environment}-ssh-brute-force"
  log_group_name = var.auth_log_group
  pattern        = "?\"Failed password\" ?\"Failed publickey\" ?\"Invalid user\""

  metric_transformation {
    name      = "SSHAuthFailureCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "ssh_brute_force_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-ssh-brute-force-alarm"
  alarm_description   = "Alarm for repeated failed SSH authentication attempts"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "SSHAuthFailureCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

# Privileged command usage from auth.log
resource "aws_cloudwatch_log_metric_filter" "sudo_usage" {
  name           = "${var.project_name}-${var.environment}-sudo-usage"
  log_group_name = var.auth_log_group
  pattern        = "\"sudo:\" && \"COMMAND=\""

  metric_transformation {
    name      = "SudoUsageCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "sudo_usage_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-sudo-usage-alarm"
  alarm_description   = "Alarm for privileged sudo command execution"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "SudoUsageCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

# NGINX error spike from nginx error log
resource "aws_cloudwatch_log_metric_filter" "nginx_error_spike" {
  name           = "${var.project_name}-${var.environment}-nginx-error-spike"
  log_group_name = var.nginx_error_log_group
  pattern        = "?\"[error]\" ?\"[crit]\" ?\"[alert]\" ?\"[emerg]\""

  metric_transformation {
    name      = "NginxErrorCount"
    namespace = "${var.project_name}/${var.environment}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "nginx_error_spike_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-nginx-error-spike-alarm"
  alarm_description   = "Alarm for spikes in NGINX error log entries"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "NginxErrorCount"
  namespace           = "${var.project_name}/${var.environment}"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

resource "aws_cloudwatch_dashboard" "security_overview" {
  dashboard_name = "${var.project_name}-${var.environment}-security-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "CloudTrail Detections"
          view    = "timeSeries"
          region  = var.aws_region
          stacked = false
          metrics = [
            ["${var.project_name}/${var.environment}", "RootAccountUsageCount"],
            [".", "ConsoleLoginFailureCount"],
            [".", "IAMPolicyChangeCount"],
            [".", "SecurityGroupChangeCount"],
            [".", "NewAccessKeyCount"]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "Host Detections"
          view    = "timeSeries"
          region  = var.aws_region
          stacked = false
          metrics = [
            ["${var.project_name}/${var.environment}", "SSHAuthFailureCount"],
            [".", "SudoUsageCount"],
            [".", "NginxErrorCount"]
          ]
        }
      }
    ]
  })
}
