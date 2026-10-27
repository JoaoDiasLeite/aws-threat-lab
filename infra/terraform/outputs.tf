output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.vpc.public_subnet_id
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "EC2 public IP"
  value       = module.ec2.public_ip
}

output "cloudtrail_bucket_name" {
  value = var.enable_logging ? module.logging[0].cloudtrail_bucket_name : null
}

output "cloudwatch_log_group_name" {
  value = var.enable_logging ? module.logging[0].cloudwatch_log_group_name : null
}

output "cloudtrail_name" {
  value = var.enable_logging ? module.logging[0].cloudtrail_name : null
}

output "ec2_instance_profile_name" {
  value = var.enable_logging ? module.logging[0].ec2_instance_profile_name : null
}

output "sns_topic_arn" {
  value = var.enable_alerts && var.enable_logging ? module.alerts[0].sns_topic_arn : null
}

output "sns_topic_name" {
  value = var.enable_alerts && var.enable_logging ? module.alerts[0].sns_topic_name : null
}

output "dashboard_name" {
  value = var.enable_alerts && var.enable_logging ? module.alerts[0].dashboard_name : null
}

output "auth_log_group_name" {
  value = var.enable_logging ? module.logging[0].auth_log_group_name : null
}

output "syslog_log_group_name" {
  value = var.enable_logging ? module.logging[0].syslog_log_group_name : null
}

output "nginx_access_log_group_name" {
  value = var.enable_logging ? module.logging[0].nginx_access_log_group_name : null
}

output "nginx_error_log_group_name" {
  value = var.enable_logging ? module.logging[0].nginx_error_log_group_name : null
}
