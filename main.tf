locals {
  template_config = yamldecode(file(var.config_template_path)) # template config from yaml to map
  merged_config = (
    var.ephemeral_spark_configured ? (
      merge(local.template_config, local.ephemeral_spark_vars, var.additional_templated_variables)
      ) : (
      merge(local.template_config, var.additional_templated_variables)
    )
  ) # merge map(string)'s of template config, ephemeral spark variables if applicable (see epehemeral-spark-config.tf), and additional variables (if provided)
}

data "template_file" "tamr_config" {
  template = yamlencode(local.merged_config)
  vars = {
    rds_pg_hostname                 = var.rds_pg_hostname, # RDS
    rds_pg_dbname                   = var.rds_pg_dbname,
    rds_pg_username                 = var.rds_pg_username,
    rds_pg_password                 = var.rds_pg_password,
    hbase_namespace                 = var.hbase_namespace, # HBase
    tamr_data_bucket                = var.tamr_data_bucket,
    hbase_config_path               = var.hbase_config_path,
    spark_emr_cluster_id            = var.spark_emr_cluster_id, # Spark
    spark_cluster_log_uri           = var.spark_cluster_log_uri
    spark_driver_memory             = var.spark_driver_memory, # Spark - Scale
    spark_executor_instances        = var.spark_executor_instances,
    spark_executor_memory           = var.spark_executor_memory,
    spark_executor_cores            = var.spark_executor_cores,
    tamr_spark_properties_override  = var.tamr_spark_properties_override,
    es_domain_endpoint              = var.es_domain_endpoint,             # Elasticsearch
    tamr_data_path                  = var.tamr_data_path,                 # FileSystem
    tamr_external_storage_providers = var.tamr_external_storage_providers # ESP
  }
}

resource "local_file" "populated_config_file" {
  count    = var.rendered_config_path == "" ? 0 : 1
  filename = var.rendered_config_path
  content  = data.template_file.tamr_config.rendered
}
