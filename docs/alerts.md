# Alerts — AWS Threat Lab

All current detections publish to a single SNS topic:

- Topic name: `aws-threat-lab-dev-security-alerts`
- Delivery method: email subscription configured from `alert_email`

## Alarm Behavior

- CloudTrail detections alert on the first matching event in a 5-minute window
- Host detections alert when the configured threshold is reached in a 5-minute window
- All alarms use `treat_missing_data = "notBreaching"`

## Current Alarm Set

### CloudTrail

- root account usage
- console login failure
- IAM policy changes
- security group changes
- new access key creation

### Host

- repeated failed SSH authentication attempts
- sudo command execution
- NGINX error spike

## Notes

- SNS email confirmation must be accepted after deployment before alerts will be delivered
- Alarm messages currently use the default CloudWatch/SNS format
- Host detections depend on CloudWatch agent log shipping remaining healthy
