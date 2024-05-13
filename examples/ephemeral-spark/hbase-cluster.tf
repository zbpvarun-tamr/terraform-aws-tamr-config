locals {
  applications = ["Hbase", "Ganglia", "Hadoop"]
}
# EMR Static HBase cluster
module "emr-hbase" {
  source = "git@github.com:Datatamer/terraform-aws-emr.git?ref=9.0.0"

  # Configurations
  create_static_cluster = true
  release_label         = "emr-6.8.0"
  applications          = local.applications
  emr_config_file_path  = "./emr-hbase-config.json"
  bucket_path_to_logs   = "logs/${local.name_prefix}-hbase/"
  tags                  = module.tags.tags

  utility_script_bucket_key = "emr-hbase-util/upload_hbase_config.sh"
  hadoop_config_path        = "emr-hbase-config/hadoop/conf/"
  hbase_config_path         = "emr-hbase-config/hbase/conf.dist/"

  # Networking
  subnet_id = local.compute_subnet_id
  vpc_id    = local.vpc_id
  # Security Group IDs
  emr_managed_master_sg_ids = module.aws-emr-sg-master.security_group_ids
  emr_managed_core_sg_ids   = module.aws-emr-sg-core.security_group_ids
  emr_service_access_sg_ids = module.aws-emr-sg-service-access.security_group_ids

  # External resource references
  bucket_name_for_root_directory = module.s3-data.bucket_name
  bucket_name_for_logs           = module.s3-logs.bucket_name
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
  key_pair_name = module.emr_key_pair.key_pair_key_name

  # Names
  cluster_name                  = "${local.name_prefix}-HBase-Cluster"
  emr_service_role_name         = "${local.name_prefix}-hbase-service-role"
  emr_ec2_role_name             = "${local.name_prefix}-hbase-ec2-role"
  emr_ec2_instance_profile_name = "${local.name_prefix}-hbase-emr-instance-profile"
  emr_service_iam_policy_name   = "${local.name_prefix}-hbase-service-policy"
  master_instance_fleet_name    = "${local.name_prefix}-HBaseMasterInstanceGroup"
  core_instance_fleet_name      = "${local.name_prefix}-HBaseCoreInstanceGroup"
  emr_managed_sg_name           = "${local.name_prefix}-EMR-Managed"

  # Scale
  master_instance_on_demand_count = local.hbase_master_instance_on_demand_count
  core_instance_on_demand_count   = local.hbase_core_instance_on_demand_count
  master_instance_type            = local.hbase_master_instance_type
  core_instance_type              = local.hbase_core_instance_type
  master_ebs_size                 = local.hbase_master_ebs_size
  core_ebs_size                   = local.hbase_core_ebs_size
}

module "sg-ports-emr" {
  source       = "git::git@github.com:Datatamer/terraform-aws-emr.git//modules/aws-emr-ports?ref=7.3.0"
  is_pre_6x    = false
  applications = local.applications
}

module "aws-emr-sg-master" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.1"
  vpc_id                  = local.vpc_id
  ingress_cidr_blocks     = local.ingress_cidr_blocks
  ingress_security_groups = concat(module.aws-sg-vm.security_group_ids, [module.ephemeral-spark-sgs.emr_managed_sg_id])
  egress_cidr_blocks      = local.egress_cidr_blocks
  ingress_ports           = module.sg-ports-emr.ingress_master_ports
  sg_name_prefix          = format("%s-%s", local.name_prefix, "emr-master")
  egress_protocol         = "all"
  ingress_protocol        = "tcp"
  tags                    = module.tags.tags
}

module "aws-emr-sg-core" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.1"
  vpc_id                  = local.vpc_id
  ingress_cidr_blocks     = local.ingress_cidr_blocks
  ingress_security_groups = concat(module.aws-sg-vm.security_group_ids, [module.ephemeral-spark-sgs.emr_managed_sg_id])
  egress_cidr_blocks      = local.egress_cidr_blocks
  ingress_ports           = module.sg-ports-emr.ingress_core_ports
  sg_name_prefix          = format("%s-%s", local.name_prefix, "emr-core")
  egress_protocol         = "all"
  ingress_protocol        = "tcp"
  tags                    = module.tags.tags
}

module "aws-emr-sg-service-access" {
  source              = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.1"
  vpc_id              = local.vpc_id
  ingress_cidr_blocks = local.ingress_cidr_blocks
  egress_cidr_blocks  = local.egress_cidr_blocks
  ingress_ports       = module.sg-ports-emr.ingress_service_access_ports
  sg_name_prefix      = format("%s-%s", local.name_prefix, "emr-service-access")
  egress_protocol     = "all"
  ingress_protocol    = "tcp"
  tags                = module.tags.tags
}
