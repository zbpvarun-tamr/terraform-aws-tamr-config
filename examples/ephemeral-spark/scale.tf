locals {
  # tamr configs:
  spark_driver_memory      = "24GB"
  spark_executor_instances = "63"
  spark_executor_memory    = "27GB"
  spark_executor_cores     = "4"
  ec2_instance_type        = "r6i.2xlarge"
  ec2_volume_size          = 250

  # spark
  master_instance_type        = "r6g.xlarge"
  core_instance_type          = "r6g.4xlarge"
  core_group_instance_count   = 16
  core_ebs_size               = 250
  master_ebs_size             = 50
  master_group_instance_count = 1

  # hbase
  hbase_master_instance_on_demand_count = 1
  hbase_core_instance_on_demand_count   = 24
  hbase_master_instance_type            = "r6g.xlarge"
  hbase_core_instance_type              = "r6g.xlarge"
  hbase_master_ebs_size                 = 50
  hbase_core_ebs_size                   = 300
}
