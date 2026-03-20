# AWS Threat Lab — Project Roadmap

This project is built in phases to demonstrate hands-on experience with AWS, Infrastructure as Code, security hardening, logging, detection engineering, and attack simulation.

The goal is to create a CV-level project that shows real cloud, DevOps, and security skills.

Scope note: optional items are deferred for now to keep costs low.

---

## Phase 1 — MVP AWS Lab (Basic working environment)

Goal: working AWS environment with logging, monitoring, and IaC.

### Infrastructure

- [x] Terraform VPC
- [x] Terraform subnet
- [x] Terraform route table + internet gateway
- [x] Terraform EC2 (t3.micro)
- [x] SSH key pair
- [x] Security group (SSH restricted, HTTP open)

### Logging / monitoring

- [x] IAM role for EC2
- [x] CloudTrail enabled
- [x] S3 bucket for CloudTrail logs
- [x] CloudWatch log groups
- [x] CloudWatch agent installed on EC2
- [x] SNS email alerts
- [x] Basic CloudWatch alarm

### Application

- [x] Ansible provisioning
- [x] NGINX reverse proxy
- [x] FastAPI backend
- [x] systemd service
- [x] backend bound to localhost only

### Validation

- [x] curl works
- [x] logs visible in CloudWatch
- [x] CloudTrail events visible

### Documentation

- [x] README
- [x] architecture diagram
- [x] repo structure

Status: COMPLETE

---

## Phase 2 — Security Hardening

Goal: make the lab look like a real production environment.

### Network security

- [x] restrict SSH to trusted IP
- [x] backend not exposed publicly
- [x] only NGINX exposed
- [ ] optional: private subnet (later)

### Host hardening

- [x] disable root login
- [x] disable password authentication
- [x] fail2ban for SSH
- [x] automatic updates
- [ ] firewall rules (optional)

### Logging improvements

- [x] nginx logs -> CloudWatch
- [x] syslog -> CloudWatch
- [x] auth.log -> CloudWatch
- [x] separate evidence S3 bucket

### Cost safety

- [x] AWS Budget
- [x] budget alarm email

### Storage

- [x] S3 evidence bucket
- [x] lifecycle rules

### Documentation

- [x] threat-model.md
- [x] hardening.md

Status: COMPLETE (optional items pending)

---

## Phase 3 — Detection Engineering

Goal: detect suspicious activity using CloudWatch and CloudTrail.

### CloudTrail detections

- [ ] Console login failure
- [ ] IAM policy change
- [ ] Root login
- [ ] Security group change
- [ ] New access key

### Host detections

- [ ] SSH brute force detection
- [ ] sudo abuse detection
- [ ] nginx error spike
- [ ] backend error spike

### CloudWatch

- [ ] metric filters
- [ ] alarms
- [ ] dashboards

### Alerts

- [ ] SNS email alerts
- [ ] readable alarm messages

### Documentation

- [ ] detections.md
- [ ] alerts.md

Status: NOT STARTED

---
## Phase 4 — Attack Simulation

Goal: prove detections work by simulating attacks.

### Simulated attacks

- [ ] SSH brute force
- [ ] fake login attempts
- [ ] API abuse
- [ ] IAM change
- [ ] console login failure
- [ ] CloudTrail tampering test

### Evidence

- [ ] logs
- [ ] screenshots
- [ ] alarm emails
- [ ] timeline

### Scripts

scripts/attack/

- ssh_attack.sh
- api_spam.sh
- iam_change.sh
- login_fail.sh

### Documentation

- [ ] incident-report.md
- [ ] attack-timeline.md

Status: NOT STARTED

---

## Phase 5 — IaC + CI/CD Polish

Goal: make the project look professional.

### Terraform

- [x] modules
- [x] variables
- [x] toggles
- [ ] workspaces (optional)

### Ansible

- [x] roles
- [x] playbook
- [ ] ansible-lint

### Makefile

- [x] deploy
- [x] destroy
- [x] ansible
- [x] wait-ssh

### GitHub

- [ ] GitHub Actions
- [ ] terraform fmt check
- [ ] terraform validate
- [ ] ansible lint

### Documentation

- [ ] setup.md
- [ ] usage.md

Status: PARTIAL

---

## Phase 6 — Advanced Features (Optional / CV boost)

Optional improvements for advanced cloud/security experience.

- [ ] Lambda auto response
- [ ] automatic IP blocking
- [ ] Wazuh integration
- [ ] multi-instance architecture
- [ ] ALB
- [ ] private subnet
- [ ] bastion host
- [ ] internal admin panel
- [ ] SIEM-style dashboard

Status: OPTIONAL

---

## Current Status

| Phase | Status |
| ----- | ------ |
| Phase 1 | DONE |
| Phase 2 | DONE |
| Phase 3 | NOT STARTED |
| Phase 4 | NOT STARTED |
| Phase 5 | PARTIAL |
| Phase 6 | OPTIONAL |

Next step: start Phase 3
