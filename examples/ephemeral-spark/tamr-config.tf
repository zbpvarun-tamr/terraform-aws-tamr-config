module "tamr-config" {
  #   source = "git::git@github.com:Datatamer/terraform-aws-tamr-config?ref=0.1.0"
  source = "../.."

  config_template_path       = "../../tamr-config.yml"
  rendered_config_path       = "./rendered-config.yml"
  ephemeral_spark_configured = true
  additional_templated_variables = {
    "TAMR_LICENSE_KEY" : "${var.license_key}"
  }

  # RDS
  rds_pg_hostname = module.rds-postgres.rds_hostname
  rds_pg_dbname   = module.rds-postgres.rds_dbname
  rds_pg_username = module.rds-postgres.rds_username
  rds_pg_password = random_password.rds-password.result
  rds_pg_db_port  = module.rds-postgres.rds_db_port

  # HBase
  hbase_namespace   = "tamr"
  tamr_data_bucket  = module.s3-data.bucket_name
  hbase_config_path = module.emr-hbase.hbase_config_path

  # Spark
  spark_emr_cluster_id           = ""
  spark_cluster_log_uri          = "s3n://${module.s3-logs.bucket_name}/${var.path_to_spark_logs}"
  tamr_data_path                 = "tamr/unify-data"
  tamr_spark_config_override = "[{'name' : 'sparkOverride1','executorInstances' : '2','sparkProps' : {'spark.cores.max' : '4'}},{'name' : 'sparkOverride2','driverMemory' : '4G','executorMemory' : '5G'}]"
  tamr_spark_properties_override = "{'spark.driver.maxResultSize':'4g'}"

  # ElasticSearch
  es_domain_endpoint = module.tamr-es-cluster.tamr_es_domain_endpoint

  # ESP
  tamr_external_storage_providers = "[{'name' : 's3a_tamr_config_test','description' : 'The S3a filesystem at root of ${module.s3-data.bucket_name}','uri' : 's3a://${module.s3-data.bucket_name}/'}]"

  # Ephemeral Spark
  emr_release_label           = "emr-5.29.0" # spark 2.4.4
  emr_instance_profile_name   = module.ephemeral-spark-iam.emr_ec2_instance_profile_name
  emr_service_role_name       = module.ephemeral-spark-iam.emr_service_role_name
  emr_key_pair_name           = module.emr_key_pair.this_key_pair_key_name
  emr_subnet_id               = var.ec2_subnet_id
  master_instance_type        = "m4.large"
  master_ebs_volumes_count    = 1
  master_ebs_size             = 50
  master_ebs_type             = "gp2"
  core_ebs_volumes_count      = 1
  core_ebs_size               = 200
  core_ebs_type               = "gp2"
  core_group_instance_count   = 4
  core_instance_type          = "r5.4xlarge"
  emr_service_access_sg_id    = module.ephemeral-spark-sgs.emr_service_access_sg_id
  emr_managed_master_sg_id    = module.ephemeral-spark-sgs.emr_managed_master_sg_id
  emr_additional_master_sg_id = module.ephemeral-spark-sgs.emr_additional_master_sg_id
  emr_managed_core_sg_id      = module.ephemeral-spark-sgs.emr_managed_core_sg_id
  emr_additional_core_sg_id   = module.ephemeral-spark-sgs.emr_additional_core_sg_id
  emrfs_dynamodb_table_name   = module.ephemeral-spark-config.emrfs_dynamodb_table_name
}

# Upload the Tamr configuration to S3
resource "aws_s3_bucket_object" "upload_tamr_config" {
  bucket                 = module.s3-data.bucket_name
  key                    = "tamr/tamr-config.yml"
  content                = module.tamr-config.rendered
  server_side_encryption = "AES256"
}
