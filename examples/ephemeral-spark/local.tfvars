name_prefix          = "tamr-config-ephemspark"
ingress_cidr_blocks  = []                    # Add VPN CIDR here and any other CIDRs to allow ingress from
ami_id               = "ami-0"               # Replace me
license_key          = "example-license-key" # Replace me
vpc_id               = "vpc-example"
ec2_subnet_id        = "subnet-us-east-1a"                        # Replace me
rds_subnet_group_ids = ["subnet-us-east-1a", "subnet-us-east-1b"] # Replace me with subnet IDs in different AZs
