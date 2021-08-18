module "tamr-es-cluster" {
  source = "git::git@github.com:Datatamer/terraform-aws-es?ref=2.1.0"

  # Names
  domain_name = "${var.name_prefix}-es"
  sg_name     = "${var.name_prefix}-es-security-group"

  # Only needed once per account, set to true if first time running in account
  create_new_service_role = false

  # In-transit encryption options
  node_to_node_encryption_enabled = true
  enforce_https                   = true

  # Networking
  vpc_id             = var.vpc_id
  subnet_ids         = [var.ec2_subnet_id]
  security_group_ids = module.aws-sg-es.security_group_ids
  # CIDR blocks to allow ingress from (i.e. VPN)
  ingress_cidr_blocks = var.ingress_cidr_blocks
  aws_region          = data.aws_region.current.name
}

data "aws_region" "current" {}

# Security Groups
module "sg-ports-es" {
  source = "git::git@github.com:Datatamer/terraform-aws-es.git//modules/es-ports?ref=2.1.0"
}

module "aws-sg-es" {
  source              = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.0"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_cidr_blocks = [
    "0.0.0.0/0"
  ]
  ingress_ports    = module.sg-ports-es.ingress_ports
  sg_name_prefix   = format("%s-%s", var.name_prefix, "-es")
  tags             = var.tags
  ingress_protocol = "tcp"
  egress_protocol  = "all"
}
