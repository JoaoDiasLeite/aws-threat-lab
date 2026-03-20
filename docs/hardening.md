# Host Hardening — AWS Threat Lab

## Overview

This document describes the security hardening applied to the EC2 instance in the AWS Threat Lab. The hardening follows industry best practices and CIS Benchmarks for Ubuntu Linux.

---

## SSH Hardening

### Configuration Changes

File: `/etc/ssh/sshd_config`

```bash
# Disable root login entirely
PermitRootLogin no

# Allow only key-based authentication (no passwords)
PasswordAuthentication no
PermitEmptyPasswords no

# Enforce strict file permissions
StrictModes yes

# Verbose logging for SSH
LogLevel VERBOSE

# Limit authentication attempts
MaxAuthTries 3
```

### Why These Changes?

| Setting | Reason |
| ------- | ------ |
| `PermitRootLogin no` | Prevents direct root compromise; eliminates high-value target |
| `PasswordAuthentication no` | Eliminates brute-force password attacks; keys are cryptographically stronger |
| `PermitEmptyPasswords no` | Ensures all accounts have passwords/keys; prevents null-password bypass |
| `StrictModes yes` | Validates home directory and SSH file permissions; prevents accidental open access |
| `LogLevel VERBOSE` | Logs all login attempts (successful & failed); enables detection of attacks |
| `MaxAuthTries 3` | Limits brute-force attempts per connection; forces attacker to reconnect |

### What Happens on SSH Login

1. Client connects with SSH key only
2. Server checks file permissions (`StrictModes`)
3. Server logs connection attempt (`LogLevel VERBOSE`)
4. Server validates key against `~/.ssh/authorized_keys`
5. If successful → login granted
6. If failed → log recorded, attempt counter incremented
7. After 3 failures → connection closed
8. Logs sent to `/var/log/auth.log` → CloudWatch → CloudWatch alarms

---

## Fail2Ban SSH Protection

### Configuration

File: `/etc/fail2ban/jail.local`

```bash
[DEFAULT]
bantime = 3600          # Ban for 1 hour
findtime = 600          # Within 10-minute window
maxretry = 3            # Ban after 3 failed attempts

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
```

### How It Works

1. fail2ban monitors `/var/log/auth.log`
2. When 3 failed SSH logins occur within 10 minutes
3. The source IP is blocked for 1 hour via `iptables`
4. Blocked IP cannot establish any connection
5. After 1 hour, IP is automatically unblocked

### Detection

- fail2ban logs to `/var/log/fail2ban/fail2ban.log`
- CloudWatch agent forwards fail2ban logs
- (Phase 3) CloudWatch alarm on fail2ban ban event

---

## Automatic Updates

### Configuration

Installed packages:

- `unattended-upgrades` — automatic security + critical updates
- `apt-listchanges` — email summaries of changes

File: `/etc/apt/apt.conf.d/50unattended-upgrades`

```bash
Unattended-Upgrade::Allowed-Origins {
  "${distro_id}:${distro_codename}-security";
  "${distro_id}ESMApps:${distro_codename}-apps-security";
  "${distro_id}ESM:${distro_codename}-infra-security";
};
Unattended-Upgrade::AutoFixDependencies "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";
Unattended-Upgrade::Remove-Unused-Boot-Grub2-Entries "true";
```

### How It Works

1. `apt` runs daily at a fixed time
2. Fetches available security & critical updates
3. Automatically installs critical security patches
4. Removes old/unused packages
5. (Optionally) sends email summary
6. System reboots automatically if kernel is updated

### Benefits

| Benefit | Impact |
| ------- | ------ |
| Automatic patching | Reduces window of vulnerability for known CVEs |
| Security focus | Only installs security/critical, not optional updates |
| Minimal disruption | Runs during off-peak hours |
| Dependency handling | Automatically fixes broken dependencies |
| Log retention | Can audit update history via `/var/log/apt/` |

---

## User Account Hardening

### Devops User

Created during Ansible provisioning:

```bash
user:
  name: devops
  groups: sudo
  shell: /bin/bash
  create_home: yes

authorized_key:
  user: devops
  key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"  # Your public key
```

### Security Implications

| Aspect | Security Benefit |
| ------ | ---------------- |
| Non-root user | Limits damage if compromised |
| sudoers access | Enables privilege escalation when needed |
| SSH key auth | No password stored on system |
| Bash shell | Standard shell for scripting |
| Home directory | Stores SSH keys and config securely |

### SSH Key Management

- **Private key**: Stored locally on your machine (`~/.ssh/id_rsa`)
- **Public key**: Stored on EC2 (`/home/devops/.ssh/authorized_keys`)
- **Permissions**: Private key 600, public key 644, `~/.ssh` dir 700
- **Backup**: Git-ignore prevents accidental commit

---

## Logging and Monitoring

### Log Sources

| Log Source | Location | Purpose |
|-----------|----------|---------|
| SSH auth | `/var/log/auth.log` | Login attempts, sudo usage |
| Syslog | `/var/log/syslog` | System events, service restarts |
| fail2ban | `/var/log/fail2ban/fail2ban.log` | Ban/unban events |
| NGINX | `/var/log/nginx/access.log` + `/var/log/nginx/error.log` | Web traffic, errors |
| Application | Application stdout | FastAPI logs |

### Log Forwarding (via CloudWatch Agent)

All logs are forwarded to CloudWatch in real-time:

- Enables centralized analysis
- Survives EC2 instance loss (not stored only on instance)
- Integrated with CloudWatch alarms
- Searchable via CloudWatch Insights

---

## S3 Evidence Bucket

### Purpose

Centralized storage for long-term audit logs:

- CloudTrail logs
- Application logs
- System logs

### Features

| Feature | Benefit |
| ------- | ------- |
| Encryption (SSE-S3) | Data protected at rest |
| Versioning | Protects against accidental/malicious deletion |
| Lifecycle Rules | Archives to Glacier after 30 days, deletes after 90 days |
| Access Logging | Logs all S3 access for audit |
| Block Public Access | Prevents accidental public exposure |

### Lifecycle Policy

```bash
0-30 days:     S3 Standard (hot data)
30-90 days:    Glacier (archived, infrequent access)
90+ days:      Deleted (permanent removal)
```

---

## AWS Budget + Cost Controls

### Monthly Budget

- **Limit**: $10 USD
- **Alert threshold**: 80% ($8)
- **Notifications**: Email alert when threshold exceeded

### Cost Control Strategy

| Strategy | Controls |
| ------- | --------- |
| t2.micro instance | Stays within free tier (~$0.01/month with some credits) |
| Minimal storage | Only stores essential logs |
| S3 lifecycle archival | Reduces storage costs over time |
| Budget limit + alert | Forces review if over budget |

### Expected Monthly Cost

- EC2 t2.micro: $0–$1 (free tier, or small charge)
- S3 storage: $0.01–$0.05 (minimal logs)
- CloudTrail: Included (first 1 CloudTrail trail free)
- CloudWatch: $0.50–$1 (logs + alarms)
- **Total**: ~$0.50–$2 USD

---

## Verification & Testing

### Verify SSH Hardening

```bash
# Attempt password login (should fail)
ssh -o PasswordAuthentication=yes ec2@instance

# Attempt key-based login (should work)
ssh -i ~/.ssh/id_rsa devops@instance

# Check SSH config is applied
ssh -i ~/.ssh/id_rsa devops@instance 'sudo grep "PermitRootLogin" /etc/ssh/sshd_config'
# Output: PermitRootLogin no
```

### Verify fail2ban

```bash
# Check fail2ban service
sudo service fail2ban status

# View current bans
sudo fail2ban-client status sshd

# Test ban behavior (Phase 4)
# Attempt SSH with wrong key 3+ times, IP should be banned
```

### Verify Automatic Updates

```bash
# Check unattended-upgrades logs
sudo cat /var/log/unattended-upgrades/unattended-upgrades.log

# Check for pending updates
sudo apt list --upgradable
```

### Verify Logs in CloudWatch

```bash
# Via AWS CLI
aws logs tail /aws/threatlab/syslog --follow

# Via AWS Console
# CloudWatch → Log Groups → Select log group → View logs
```

---

## Maintenance

### Monthly Tasks

- [ ] Review AWS Budgets email alerts
- [ ] Check CloudTrail logs for suspicious activity
- [ ] Review fail2ban bans (if any)
- [ ] Update rootless user SSH keys annually

### Annual Tasks

- [ ] Rotate SSH keys
- [ ] Review password policies
- [ ] Audit IAM permissions
- [ ] Review S3 bucket access logs

---

## References

- [CIS Ubuntu Linux 20.04 LTS Benchmark](https://www.cisecurity.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [fail2ban Documentation](https://www.fail2ban.org/)
- [Ubuntu SSH Best Practices](https://manpages.ubuntu.com/manpages/focal/man5/sshd_config.5.html)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
