# Architecture

## Overview

The AWS Threat Lab is a small production-style cloud environment designed to demonstrate infrastructure provisioning, hardening, centralized logging, detection engineering, and attack simulation.

## Components

- VPC with a public subnet
- EC2 instance running:
  - NGINX reverse proxy
  - FastAPI backend
  - CloudWatch Agent
  - fail2ban
- IAM role attached to EC2
- CloudTrail for AWS API activity
- CloudWatch Logs for AWS and host logs
- SNS for email alerting
- S3 bucket for CloudTrail log storage

## Mermaid Diagram

```mermaid
flowchart TD
    U[User / Tester] -->|HTTP| NGINX[NGINX Reverse Proxy on EC2]
    NGINX --> APP[FastAPI Backend]
    APP --> LOGS[Local App and NGINX Logs]

    EC2[EC2 Instance] --> CWAGENT[CloudWatch Agent]
    CWAGENT --> CWLOGS[CloudWatch Logs]

    AWSAPI[AWS Account Activity] --> CLOUDTRAIL[CloudTrail]
    CLOUDTRAIL --> S3[S3 Log Bucket]
    CLOUDTRAIL --> CWLOGS

    CWLOGS --> FILTERS[Metric Filters and Alarms]
    FILTERS --> SNS[SNS Email Alerts]

    IAM[IAM Role and Instance Profile] --> EC2
```

---
