module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "logging" {
  count  = var.enable_logging ? 1 : 0
  source = "./modules/logging"

  project_name            = var.project_name
  environment             = var.environment
  aws_region              = var.aws_region
  aws_account_id          = var.aws_account_id
  ec2_role_name           = "${var.project_name}-${var.environment}-ec2-role"
  trail_name              = "${var.project_name}-${var.environment}-trail"
  log_group_name          = "/aws/cloudtrail/${var.project_name}-${var.environment}"
  s3_bucket_name          = "${var.project_name}-${var.environment}-cloudtrail-logs-${var.aws_account_id}"
  host_log_retention_days = var.host_log_retention_days
}

module "ec2" {
  source = "./modules/ec2"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  subnet_id                 = module.vpc.public_subnet_id
  instance_type             = var.instance_type
  ami_id                    = var.ami_id
  allowed_ssh_cidr          = var.allowed_ssh_cidr
  key_name                  = var.key_name
  iam_instance_profile_name = var.enable_logging ? module.logging[0].ec2_instance_profile_name : null
}

module "alerts" {
  count  = var.enable_alerts && var.enable_logging ? 1 : 0
  source = "./modules/alerts"

  project_name         = var.project_name
  environment          = var.environment
  alert_email          = var.alert_email
  cloudwatch_log_group = module.logging[0].cloudwatch_log_group_name
}