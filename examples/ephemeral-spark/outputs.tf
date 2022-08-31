output "tamr-vm" {
  value = module.tamr-vm
}

output "rds-postgres" {
  value = module.rds-postgres
}

output "rds-pw" {
  value     = random_password.rds-password
  sensitive = true
}

output "opensearch" {
  value = module.tamr-opensearch-cluster
}

output "ec2-key" {
  value = module.emr_key_pair
}

output "private-key" {
  value     = tls_private_key.emr_private_key.private_key_pem
  sensitive = true
}

output "emr-hbase" {
  value = module.emr-hbase
}

output "ephemeral-spark-iam" {
  value = module.ephemeral-spark-iam
}

output "ephemeral-spark-sgs" {
  value = module.ephemeral-spark-sgs
}

output "tamr-config" {
  value     = module.tamr-config.rendered
  sensitive = true
}

output "aws-sg-vm" {
  value = module.aws-sg-vm
}
