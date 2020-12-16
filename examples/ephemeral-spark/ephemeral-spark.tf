# Ephemeral Spark cluster
module "ephemeral-spark-sgs" {
  source                        = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-sgs?ref=0.11.1"
  applications                  = ["Spark"]
  vpc_id                        = var.vpc_id
  emr_managed_master_sg_name    = "${var.name_prefix}-EMR-Spark-Master"
  emr_managed_core_sg_name      = "${var.name_prefix}-EMR-Spark-Core"
  emr_additional_master_sg_name = "${var.name_prefix}-EMR-Spark-Additional-Master"
  emr_additional_core_sg_name   = "${var.name_prefix}-EMR-Spark-Additional-Core"
  emr_service_access_sg_name    = "${var.name_prefix}-EMR-Spark-Service-Access"
}

module "ephemeral-spark-iam" {
  source                            = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-iam?ref=0.11.1"
  s3_bucket_name_for_logs           = module.s3-logs.bucket_name
  s3_bucket_name_for_root_directory = module.s3-data.bucket_name
  s3_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
  emrfs_metadata_table_name     = "${var.name_prefix}-Spark-EmrFSMetadata"
  emr_ec2_iam_policy_name       = "${var.name_prefix}-spark-ec2-policy"
  emr_service_iam_policy_name   = "${var.name_prefix}-spark-service-policy"
  emr_service_role_name         = "${var.name_prefix}-spark-service-role"
  emr_ec2_instance_profile_name = "${var.name_prefix}-spark-emr-instance-profile"
  emr_ec2_role_name             = "${var.name_prefix}-spark-ec2-role"
}

module "ephemeral-spark-config" {
  source                         = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-config?ref=0.11.1"
  create_static_cluster          = false
  cluster_name                   = "${var.name_prefix}-Spark-Cluster" # unused
  emr_config_file_path           = "./emr.json"
  emrfs_metadata_table_name      = "${var.name_prefix}-Spark-EmrFSMetadata"
  bucket_name_for_root_directory = module.s3-data.bucket_name
}
