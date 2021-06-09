variable "config_template_path" {
  type        = string
  description = "Path to Tamr config template."
  default     = "./tamr-config.yml"
}

variable "rendered_config_path" {
  type        = string
  description = "If provided, the populated Tamr config will be output to this path. Include a file name (E.g. /path/to/config.yml). NOTE: Any required parent directories will be created automatically, and any existing file with the given name will be overwritten."
  default     = ""
}

variable "ephemeral_spark_configured" {
  type        = bool
  description = "True if EMR was configured for ephemeral spark clusters."
}

variable "additional_templated_variables" {
  type        = map(string)
  description = "Mapping of additional Tamr variables (not included in template) to its value. If a variable name in this map defines the same key as an input variable, the value specified in this map takes precedence."
  default     = {}
}

#
# RDS
#

variable "rds_pg_hostname" {
  type        = string
  description = "Hostname of RDS postgres instance."
}

variable "rds_pg_dbname" {
  type        = string
  description = "RDS postgres database name."
  default     = "doit"
}

variable "rds_pg_username" {
  type        = string
  description = "Master username for RDS postgres database instance."
  default     = "tamr"
}

variable "rds_pg_password" {
  type        = string
  description = "Master password for RDS postgres database instance."
}

variable "rds_pg_db_port" {
  type        = number
  description = "The RDS postgres database port."
  default     = 5432
}

#
# HBase
#

variable "hbase_namespace" {
  type    = string
  default = "tamr"
}

variable "tamr_data_bucket" {
  type        = string
  description = "Name of Tamr root directory bucket."
}

variable "hbase_config_path" {
  type        = string
  description = "Path to HBase configuration in EMR root directory bucket."
  default     = "config/hbase/conf.dist/"
}

#
# Spark
#

variable "spark_emr_cluster_id" {
  type        = string
  description = "Spark cluster ID. Value will not be used if deployment is spinning up ephemeral Spark clusters."
  default     = ""
}

variable "spark_cluster_log_uri" {
  type        = string
  description = "The path to the S3 location where logs for the Spark cluster are stored."
}

#
# Spark - Scale
#

variable "spark_driver_memory" {
  type    = string
  default = "5G"
}

variable "spark_executor_instances" {
  type    = number
  default = 2
}

variable "spark_executor_memory" {
  type    = string
  default = "8G"
}

variable "spark_executor_cores" {
  type    = number
  default = 2
}

variable "tamr_spark_config_override" {
  type        = string
  description = "A list of spark config overrides. If not set all jobs will run with the default spark settings. Used for setting job-by-job spark resource settings."
  default     = ""
}

variable "tamr_spark_properties_override" {
  type        = string
  description = "JSON blob of spark properties to override. If not set, will use a default set of properties that should work for most use cases."
  default     = ""
}

#
# Elasticsearch
#

variable "es_domain_endpoint" {
  type        = string
  description = "Endpoint of Elasticsearch domain."
}

#
# FileSystem
#

variable "tamr_data_path" {
  type        = string
  description = "Path in root directory bucket (bucket provided for tamr_bucket_name input) to write data to."
  default     = "tamr/unify-data"
}

#
# ESP
#

variable "tamr_external_storage_providers" {
  type        = string
  description = "Filesystem connection information for external storage providers."
  default     = ""
}

#
# Ephemeral Spark
#

variable "emr_release_label" {
  type        = string
  description = "The release label for the Amazon EMR release."
  default     = "emr-5.29.0"
}

variable "emr_instance_profile_name" {
  type        = string
  description = "Name of instance profile for EMR EC2 instances."
  default     = ""
}

variable "emr_service_role_name" {
  type        = string
  description = "Name of IAM service role for EMR cluster."
  default     = ""
}

variable "emr_key_pair_name" {
  type        = string
  description = "Name of the Key Pair that will be attached to the EMR EC2 instances."
  default     = ""
}

variable "emr_subnet_id" {
  type        = string
  description = "ID of the subnet where the EMR cluster will be created."
  default     = ""
}

variable "master_instance_type" {
  type        = string
  description = "The EC2 instance type of the master nodes."
  default     = ""
}

variable "master_ebs_volumes_count" {
  type        = string
  description = "Number of volumes to attach to the master nodes."
  default     = ""
}

variable "master_ebs_size" {
  type        = string
  description = "The master EBS volume size, in gibibytes (GiB)."
  default     = ""
}

variable "master_ebs_type" {
  type        = string
  description = "Type of volumes to attach to the master nodes. Valid options are gp2, io1, standard and st1."
  default     = ""
}

variable "core_ebs_volumes_count" {
  type        = string
  description = "Number of volumes to attach to the core nodes."
  default     = ""
}

variable "core_ebs_size" {
  type        = string
  description = "The core EBS volume size, in gibibytes (GiB)."
  default     = ""
}

variable "core_ebs_type" {
  type        = string
  description = "Type of volumes to attach to the core nodes. Valid options are gp2, io1, standard and st1."
  default     = ""
}

variable "core_group_instance_count" {
  type        = string
  description = "Number of Amazon EC2 instances used to execute the job flow."
  default     = ""
}

variable "core_instance_type" {
  type        = string
  description = "The EC2 instance type of the core nodes."
  default     = ""
}

variable "emr_service_access_sg_id" {
  type        = string
  description = "Security group ID of EMR Service Access Security Group."
  default     = ""
}

variable "emr_managed_master_sg_id" {
  type        = string
  description = "Security group ID of the EMR Managed Master Security Group."
  default     = ""
}

variable "emr_additional_master_sg_id" {
  type        = string
  description = "Security group ID of the EMR Additional Master Security Group."
  default     = ""
}

variable "emr_managed_core_sg_id" {
  type        = string
  description = "Security group ID of the EMR Managed Core Security Group."
  default     = ""
}

variable "emr_additional_core_sg_id" {
  type        = string
  description = "Security group ID of the EMR Additional Core Security Group."
  default     = ""
}

variable "emrfs_dynamodb_table_name" {
  type        = string
  description = "Name for the EMRFS DynamoDB table."
  default     = ""
}

variable "emr_root_volume_size" {
  default     = "10"
  type        = string
  description = "The size, in GiB, of the EBS root device volume of the Linux AMI that is used for each EMR EC2 instance."
}

#
# Backup Config
#

variable "tamr_file_based_hbase_backup_enabled" {
  type        = bool
  description = "Whether to backup contents of HBase root directory to backup path"
  default     = true
}

variable "tamr_backup_aws_cli_enabled" {
  type        = bool
  description = "Whether to use the AWS S3 command line utility when backing up to or from S3. Note that the AWS S3 CLI will only be used when this is true and it is installed locally"
  default     = true
}

variable "tamr_unify_backup_es" {
  type        = bool
  description = "Defines whether or not to back up Elasticsearch"
  default     = false
}

variable "tamr_unify_backup_aws_role_based_access" {
  type        = bool
  description = "Set to `true` if Tamr should use EC2 instance profile (role-based) credentials instead of static credentials"
  default     = true
}

variable "tamr_unify_backup_path" {
  type        = string
  description = "Identifies the path for storing backup files"
  default     = "tamr/backups"
}

#
# DMS Config
#

variable "apps_dms_enabled" {
  type        = bool
  description = "Set to `true` to enable the  Data Movement Service (DMS)"
  default     = true
}

variable "apps_dms_default_cloud_provider" {
  type        = string
  description = "Defines the default cloud service provider for DMS when `APPS_DMS_ENABLED` is set to `true`"
  default     = "s3"
}
