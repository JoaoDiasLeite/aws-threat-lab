output "bucket_name" {
  value       = aws_s3_bucket.evidence.bucket
  description = "Evidence bucket name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.evidence.arn
  description = "Evidence bucket ARN"
}

output "bucket_id" {
  value       = aws_s3_bucket.evidence.id
  description = "Evidence bucket ID"
}
