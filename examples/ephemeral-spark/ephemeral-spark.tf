# Ephemeral Spark cluster
module "ephemeral-spark-sgs" {
  source                    = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-sgs?ref=9.0.0"
  vpc_id                    = var.vpc_id
  emr_managed_sg_name       = format("%s-%s", var.name_prefix, "Ephem-Spark-Internal")
  emr_service_access_sg_ids = module.aws-emr-sg-service-access.security_group_ids
  tags                      = merge(var.tags, var.emr_tags)
}

module "ephemeral-spark-iam" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-iam?ref=9.0.0"
  s3_bucket_name_for_logs = module.s3-logs.bucket_name
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
  vpc_id                        = var.vpc_id
  emr_service_iam_policy_name   = "${var.name_prefix}-spark-service-policy"
  emr_service_role_name         = "${var.name_prefix}-spark-service-role"
  emr_ec2_instance_profile_name = "${var.name_prefix}-spark-emr-instance-profile"
  emr_ec2_role_name             = "${var.name_prefix}-spark-ec2-role"
  tags                          = var.tags
}
