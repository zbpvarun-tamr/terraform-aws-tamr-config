# Ephemeral Spark cluster
module "ephemeral-spark-sgs" {
  source                    = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-sgs?ref=9.0.0"
  vpc_id                    = local.vpc_id
  emr_managed_sg_name       = format("%s-%s", local.name_prefix, "Ephem-Spark-Internal")
  emr_service_access_sg_ids = module.aws-emr-sg-service-access.security_group_ids
  tags                      = module.tags.tags
}

module "ephemeral-spark-iam" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-iam?ref=9.0.0"
  s3_bucket_name_for_logs = module.s3-logs.bucket_name
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
  vpc_id                        = local.vpc_id
  emr_service_iam_policy_name   = "${local.name_prefix}-spark-service-policy"
  emr_service_role_name         = "${local.name_prefix}-spark-service-role"
  emr_ec2_instance_profile_name = "${local.name_prefix}-spark-emr-instance-profile"
  emr_ec2_role_name             = "${local.name_prefix}-spark-ec2-role"
  tags                          = module.tags.tags
}

module "ephemeral-spark-config" {
  source                         = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-config?ref=9.0.0"
  create_static_cluster          = false
  emr_config_file_path           = "${path.module}/emr-spark-config.json"
  bucket_name_for_root_directory = module.s3-data.bucket_name

  utility_script_bucket_key = "ephemeral-spark-util/upload_hbase_config.sh"
  hadoop_config_path        = "ephemeral-spark-config/hadoop/conf/"
  hbase_config_path         = "ephemeral-spark-config/hbase/conf.dist/"
}

module "ephemeral-spark-sg-service-access" {
  source              = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.1"
  vpc_id              = local.vpc_id
  ingress_ports       = module.aws-vm-sg-ports.ingress_ports
  ingress_cidr_blocks = local.ingress_cidr_blocks
  egress_cidr_blocks  = local.egress_cidr_blocks
  sg_name_prefix      = format("%s-%s", local.name_prefix, "spark-emr-service-access")
  egress_protocol     = "all"
  ingress_protocol    = "tcp"
  tags                = module.tags.tags
}
