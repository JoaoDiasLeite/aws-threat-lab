# Threat Model — AWS Threat Lab

## Overview

The AWS Threat Lab is designed to simulate a realistic cloud environment for demonstrating detection engineering and security hardening. This document outlines the potential threats and how they are mitigated.

---

## Assets

1. **EC2 Instance** — main application server running NGINX + FastAPI
2. **Data** — application logs, CloudTrail logs, authentication logs
3. **Network infrastructure** — VPC, subnets, security groups, IAM roles
4. **CloudWatch logs** — centralized log collection
5. **CloudTrail** — AWS API audit log

---

## Threat Categories

### 1. Unauthorized SSH Access

**Threat**: Attacker gains SSH access to the EC2 instance

**Attack vectors**:
- Brute-force SSH password attacks
- Leaked SSH key
- Weak SSH key configuration
- Root login exploitation

**Mitigations**:
- ✅ Disable root login (`PermitRootLogin no`)
- ✅ Disable password authentication (key-only SSH)
- ✅ Enable fail2ban (SSH brute-force protection)
- ✅ Restrict SSH to trusted IP via security group
- ✅ SSH key stored securely locally
- ✅ High log level for SSH (VERBOSE)
- ✅ Max 3 authentication attempts per connection

**Detection**:
- Failed login attempts logged to syslog → CloudWatch
- fail2ban alerts on repeated failed login
- CloudWatch alarm on high authentication failure rate

---

### 2. Privilege Escalation

**Threat**: Attacker escalates privileges to become root or execute unauthorized commands

**Attack vectors**:
- sudo without password
- Misconfigured sudoers file
- Kernel or service vulnerabilities

**Mitigations**:
- ✅ Devops user added to sudoers for privilege escalation
- ✅ SSH key-only authentication (no plaintext passwords)
- ⚠️ Automatic security updates enabled
- ⚠️ Regular patching via unattended-upgrades

**Detection**:
- sudo usage logged to auth.log → CloudWatch
- Unexpected sudo commands logged and alarmed
- (Phase 3) Detect unauthorized sudo usage pattern

---

### 3. Compromised Application

**Threat**: FastAPI backend exploited to execute arbitrary code or access data

**Attack vectors**:
- SQL injection (if database used later)
- API injection attacks
- Deserialization attacks
- Path traversal

**Mitigations**:
- ✅ Backend bound to localhost (not exposed publicly)
- ✅ NGINX reverse proxy in front of application
- ✅ Only HTTP/HTTPS exposed to internet
- ⚠️ Application runs as non-root user
- ⚠️ Application logs sent to CloudWatch

**Detection**:
- (Phase 3) NGINX error spike alarm
- (Phase 3) Backend error spike alarm
- (Phase 4) Simulated API abuse detection

---

### 4. Unauthorized API Change

**Threat**: Attacker modifies AWS infrastructure via compromised credentials

**Attack vectors**:
- Leaked AWS credentials
- Compromised IAM user
- Role assumption attack

**Mitigations**:
- ✅ CloudTrail enabled and sent to S3
- ✅ CloudTrail logs centralized to CloudWatch
- ✅ IAM roles used instead of user credentials on EC2
- ✅ Minimal IAM permissions (principle of least privilege)

**Detection**:
- (Phase 3) CloudTrail metric filter for IAM policy changes
- (Phase 3) CloudTrail metric filter for security group changes
- (Phase 3) CloudTrail metric filter for new access keys
- (Phase 3) SNS alert on detected changes

---

### 5. Cost Overrun / Resource Exhaustion

**Threat**: Attacker launches expensive resources or performs denial-of-service

**Attack vectors**:
- Launching expensive compute instances
- Transferring large amounts of data
- DDoS triggering expensive autoscaling

**Mitigations**:
- ✅ AWS Budget with monthly limit ($10 USD)
- ✅ Budget alarm set at 80% threshold
- ✅ Email notification on budget exceeded
- ✅ EC2 instance restricted to t2.micro

**Detection**:
- Budget alert email sent when threshold exceeded
- (Manual) Review AWS costs dashboard

---

### 6. Unauthorized Access to Logs

**Threat**: Attacker deletes or tampers with audit logs to hide activity

**Attack vectors**:
- Gaining EC2 root access → delete local logs
- Accessing S3 directly → delete CloudTrail logs
- Disabling CloudTrail

**Mitigations**:
- ✅ Logs stored in multiple locations (CloudWatch + S3)
- ✅ S3 versioning enabled on evidence bucket
- ✅ Evidence bucket in separate AWS account (future)
- ✅ CloudTrail cannot be disabled by EC2 role (no permissions)
- ⚠️ Log retention set to 90 days minimum
- ⚠️ S3 lifecycle archival to Glacier after 30 days

**Detection**:
- (Phase 3) Detect CloudTrail logging disabled
- (Phase 3) Detect S3 object deletion
- (Manual) Review CloudTrail logs for data plane events

---

## Security Assumptions

1. **SSH key is secure** — stored locally, never committed to Git, never shared
2. **Trusted IP is correct** — SSH CIDR is accurate and includes only trusted sources
3. **AWS account is secure** — email alerts are received and acted upon
4. **No privilege escalation exploits** — kernel and service vulnerabilities are patched regularly
5. **No application vulnerabilities** — FastAPI code is reviewed for security issues

---

## Out of Scope (Phase 2)

- Private subnet / bastion host
- WAF (Web Application Firewall)
- DDoS protection (AWS Shield Standard is always on)
- Encryption in transit (TLS) — future phase
- Secrets management (AWS Secrets Manager) — future phase
- Multi-region failover
- SIEM integration

---

## Residual Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|-----------|
| SSH key compromise | Low | High | Key rotation policy |
| Application vulnerability | Medium | High | Code review, penetration testing |
| CloudTrail tampering | Low | Critical | Versioning + cross-account storage |
| Privilege escalation | Low | High | Regular patching + monitoring |
| Budget overage | Low | Medium | Alert + review |

---

## Compliance Notes

This lab demonstrates:
- ✅ Principle of least privilege
- ✅ Defense in depth (multiple layers)
- ✅ Logging and monitoring
- ✅ Incident response capabilities (Phase 3)
- ✅ Cost control measures

Not intended for production use; this is a learning/demonstration environment.
