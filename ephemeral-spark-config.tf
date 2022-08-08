locals {
  ephemeral_spark_vars = {
    "TAMR_JOB_SPARK_CLUSTER" : "emr-ephemeral",
    "TAMR_JOB_EMR_CLUSTER_ID" : "",
    "TAMR_DATASET_EMR_RELEASE" : var.emr_release_label,
    "TAMR_DATASET_EMR_INSTANCE_PROFILE" : var.emr_instance_profile_name,
    "TAMR_DATASET_EMR_SERVICE_ROLE" : var.emr_service_role_name,
    "TAMR_DATASET_EMR_KEY_NAME" : var.emr_key_pair_name,
    "TAMR_DATASET_EMR_SUBNET_ID" : var.emr_subnet_id,
    "TAMR_DATASET_EMR_MASTER_INSTANCE_TYPE" : var.master_instance_type,
    "TAMR_DATASET_EMR_MASTER_VOLUME_COUNT" : var.master_ebs_volumes_count,
    "TAMR_DATASET_EMR_MASTER_VOLUME_SIZE" : var.master_ebs_size,
    "TAMR_DATASET_EMR_MASTER_VOLUME_TYPE" : var.master_ebs_type,
    "TAMR_DATASET_EMR_CORE_VOLUME_COUNT" : var.core_ebs_volumes_count,
    "TAMR_DATASET_EMR_CORE_VOLUME_SIZE" : var.core_ebs_size,
    "TAMR_DATASET_EMR_CORE_VOLUME_TYPE" : var.core_ebs_type,
    "TAMR_DATASET_EMR_INSTANCE_COUNT" : var.core_group_instance_count,
    "TAMR_DATASET_EMR_INSTANCE_TYPE" : var.core_instance_type,
    "TAMR_DATASET_EMR_ACCESS_SECURITY_GROUP" : var.emr_service_access_sg_id,
    "TAMR_DATASET_EMR_MASTER_SECURITY_GROUP" : var.emr_managed_master_sg_id,
    "TAMR_DATASET_EMR_MASTER_SECURITY_GROUP_ADDITIONAL" : var.emr_additional_master_sg_id,
    "TAMR_DATASET_EMR_WORKER_SECURITY_GROUP" : var.emr_managed_core_sg_id,
    "TAMR_DATASET_EMR_WORKER_SECURITY_GROUP_ADDITIONAL" : var.emr_additional_core_sg_id,
    "TAMR_EMRFS_DYNAMO_TABLE" : var.emrfs_dynamodb_table_name,
    "TAMR_DATASET_EMR_ROOT_VOLUME_SIZE" : var.emr_root_volume_size,
    "TAMR_DATASET_EMR_CLUSTER_NAME_PREFIX" : var.emr_cluster_name_prefix,
    "TAMR_DATASET_EMR_CLUSTER_TAGS" : join(",", flatten([for i, k in var.emr_tags : concat([i], [k])]))
  }
}
