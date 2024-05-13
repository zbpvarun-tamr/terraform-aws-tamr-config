locals {
  vpc_id = "" # enter a valid vpc id

  # Fill with valid subnets for ec2 and rds instances
  ec2-private-a = ""
  ec2-private-b = ""
  ec2-private-c = ""
  rds-private-a = ""
  rds-private-b = ""
  rds-private-c = ""

  compute_subnet_id = local.ec2-private-a
  data_subnet_ids   = [local.ec2-private-a, local.ec2-private-b]

  # Fill with corresponding cidr blocks
  ingress_cidr_blocks = [""]
  egress_cidr_blocks  = [""]

}
