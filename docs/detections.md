# Detections — AWS Threat Lab

This document tracks the detections currently implemented in Terraform and the ones still planned.

## Implemented Detections

### CloudTrail

| Detection | Source | Trigger | Alarm Threshold |
| --- | --- | --- | --- |
| Root account usage | CloudTrail log group | `userIdentity.type = Root` and not an AWS service event | `>= 1` in 5 minutes |
| Console login failure | CloudTrail log group | `ConsoleLogin` with `Failed authentication` | `>= 1` in 5 minutes |
| IAM policy change | CloudTrail log group | IAM policy create/update/delete and attach/detach events | `>= 1` in 5 minutes |
| Security group change | CloudTrail log group | Security group create/delete/authorize/revoke events | `>= 1` in 5 minutes |
| New access key | CloudTrail log group | `CreateAccessKey` events from IAM | `>= 1` in 5 minutes |

### Host Logs

| Detection | Source | Trigger | Alarm Threshold |
| --- | --- | --- | --- |
| SSH brute force attempts | `/aws/ec2/aws-threat-lab/dev/auth` | `Failed password`, `Failed publickey`, or `Invalid user` | `>= 5` in 5 minutes |
| sudo usage | `/aws/ec2/aws-threat-lab/dev/auth` | auth log entries containing `sudo:` and `COMMAND=` | `>= 1` in 5 minutes |
| NGINX error spike | `/aws/ec2/aws-threat-lab/dev/nginx/error` | error log entries containing `[error]`, `[crit]`, `[alert]`, or `[emerg]` | `>= 5` in 5 minutes |

## Dashboard

A CloudWatch dashboard named `aws-threat-lab-dev-security-overview` is created by Terraform.

It includes:

- CloudTrail detection metrics
- Host detection metrics

## Still Planned

- backend error spike detection
- more selective sudo abuse logic
- readable/customized alarm messaging
- attack validation and evidence capture
