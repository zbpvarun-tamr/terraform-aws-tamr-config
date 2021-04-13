This example demonstrates a terraform-generated Tamr config for a full aws-scale out environment set up for ephemeral Spark clusters. The environment consists of:
- static EMR deployment running HBase
- EMR deployment setting up infra for ephemeral Spark cluster
- data bucket and logs bucket to be shared by static HBase cluster and ephemeral Spark clusters
- newly-generated EC2 key pair (used by both Tamr VM and EMR EC2 instances)
- Elasticsearch domain
- RDS Postgres instance
- Tamr VM deployment

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_id | AMI to use for Tamr EC2 instance | `string` | n/a | yes |
| ec2\_subnet\_id | Subnet ID for ElasticSearch domain, Tamr VM, EMR cluster | `string` | n/a | yes |
| license\_key | Tamr license key | `string` | n/a | yes |
| rds\_subnet\_group\_ids | List of at least 2 subnet IDs in different AZs | `list(string)` | n/a | yes |
| vpc\_id | VPC ID of deployment | `string` | n/a | yes |
| ingress\_cidr\_blocks | List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR) | `list(string)` | `[]` | no |
| name\_prefix | A prefix to add to the names of all created resources. | `string` | `"tamr-config-test"` | no |
| path\_to\_spark\_logs | Path in logs bucket to store spark logs. E.g. tamr/spark-logs | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| ec2-key | n/a |
| elasticsearch | n/a |
| emr-hbase | n/a |
| ephemeral-spark-config | n/a |
| ephemeral-spark-iam | n/a |
| ephemeral-spark-sgs | n/a |
| private-key | n/a |
| rds-postgres | n/a |
| rds-pw | n/a |
| tamr-config | n/a |
| tamr-vm | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
