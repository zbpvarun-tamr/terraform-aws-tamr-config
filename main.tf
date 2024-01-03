locals {
  s3_dist_cp     = var.tamr_backup_emr_cluster_id != "" ? "true" : "false"
  backup_aws_cli = var.tamr_backup_emr_cluster_id == "" ? "true" : "false"

  default_tamr_config = templatefile("${path.module}/${var.config_template_path}", {
    rds_pg_hostname                         = var.rds_pg_hostname, # RDS
    rds_pg_dbname                           = var.rds_pg_dbname,
    rds_pg_username                         = var.rds_pg_username,
    rds_pg_password                         = var.rds_pg_password,
    rds_pg_db_port                          = var.rds_pg_db_port,
    hbase_namespace                         = var.hbase_namespace, # HBase
    tamr_data_bucket                        = var.tamr_data_bucket,
    hbase_config_path                       = var.hbase_config_path,
    hbase_storage_mode                      = var.hbase_storage_mode,
    hbase_number_of_regions                 = var.hbase_number_of_regions,
    hbase_number_of_salt_values             = var.hbase_number_of_salt_values,
    spark_emr_cluster_id                    = var.spark_emr_cluster_id, # Spark
    emr_release_label                       = var.emr_release_label,
    emr_instance_profile_name               = var.emr_instance_profile_name,
    emr_service_role_name                   = var.emr_service_role_name,
    emr_key_pair_name                       = var.emr_key_pair_name,
    emr_subnet_id                           = var.emr_subnet_id,
    master_instance_type                    = var.master_instance_type,
    master_ebs_volumes_count                = var.master_ebs_volumes_count,
    master_ebs_size                         = var.master_ebs_size,
    master_ebs_type                         = var.master_ebs_type,
    core_ebs_volumes_count                  = var.core_ebs_volumes_count,
    core_ebs_size                           = var.core_ebs_size,
    core_ebs_type                           = var.core_ebs_type,
    core_group_instance_count               = var.core_group_instance_count,
    core_instance_type                      = var.core_instance_type,
    emr_service_access_sg_id                = var.emr_service_access_sg_id,
    emr_managed_master_sg_id                = var.emr_managed_master_sg_id,
    emr_managed_core_sg_id                  = var.emr_managed_core_sg_id,
    emr_additional_master_sg_id             = var.emr_additional_master_sg_id,
    emr_additional_core_sg_id               = var.emr_additional_core_sg_id,
    emrfs_dynamodb_table_name               = var.emrfs_dynamodb_table_name,
    emr_root_volume_size                    = var.emr_root_volume_size,
    emr_cluster_name_prefix                 = var.emr_cluster_name_prefix,
    emr_cluster_tags                        = join(",", flatten([for i, k in var.emr_tags : concat([i], [k])])),
    emr_security_configuration              = var.emr_security_configuration,
    spark_cluster_log_uri                   = var.spark_cluster_log_uri,
    spark_driver_memory                     = var.spark_driver_memory, # Spark - Scale
    spark_executor_instances                = var.spark_executor_instances,
    spark_executor_memory                   = var.spark_executor_memory,
    spark_executor_cores                    = var.spark_executor_cores,
    tamr_spark_config_override              = var.tamr_spark_config_override,
    tamr_spark_properties_override          = var.tamr_spark_properties_override,
    es_domain_endpoint                      = var.es_domain_endpoint,                   # Elasticsearch
    es_enabled                              = var.es_enabled,
    remote_es_enabled                       = var.es_domain_endpoint != "",
    es_api_host                             = var.es_domain_endpoint != "" ? "${var.es_domain_endpoint}:443" : "localhost:9200",
    es_ssl_enabled                          = var.es_domain_endpoint != "",
    tamr_data_path                          = var.tamr_data_path,                       # FileSystem
    tamr_external_storage_providers         = var.tamr_external_storage_providers,      # ESP
    tamr_file_based_hbase_backup_enabled    = var.tamr_file_based_hbase_backup_enabled, # Backup
    tamr_backup_aws_cli_enabled             = local.backup_aws_cli,
    tamr_unify_backup_es                    = var.tamr_unify_backup_es,
    tamr_unify_backup_aws_role_based_access = var.tamr_unify_backup_aws_role_based_access,
    tamr_unify_backup_path                  = var.tamr_unify_backup_path,
    tamr_backup_s3distcp_enabled            = local.s3_dist_cp,
    tamr_backup_emr_cluster_id              = var.tamr_backup_emr_cluster_id,
    apps_dms_enabled                        = var.apps_dms_enabled, # DMS
    apps_dms_default_cloud_provider         = var.apps_dms_default_cloud_provider
    })
}

resource "local_file" "populated_config_file" {
  count    = var.rendered_config_path == "" ? 0 : 1
  filename = var.rendered_config_path
  content  = local.default_tamr_config
}
