output "cloudtrail_bucket_name" {
  value = aws_s3_bucket.cloudtrail.id
}

output "cloudtrail_bucket_arn" {
  value = aws_s3_bucket.cloudtrail.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail.name
}

output "cloudtrail_name" {
  value = aws_cloudtrail.this.name
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "auth_log_group_name" {
  value = aws_cloudwatch_log_group.auth.name
}

output "syslog_log_group_name" {
  value = aws_cloudwatch_log_group.syslog.name
}

output "nginx_access_log_group_name" {
  value = aws_cloudwatch_log_group.nginx_access.name
}

output "nginx_error_log_group_name" {
  value = aws_cloudwatch_log_group.nginx_error.name
}