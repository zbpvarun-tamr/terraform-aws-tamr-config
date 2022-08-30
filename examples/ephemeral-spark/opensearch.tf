module "tamr-opensearch-cluster" {
  source = "git::git@github.com:Datatamer/terraform-aws-opensearch?ref=6.0.0"

  # Names
  domain_name = "${var.name_prefix}-opensearch"

  # In-transit encryption options
  node_to_node_encryption_enabled = true
  enforce_https                   = true

  # Networking
  subnet_ids         = [var.data_subnet_ids[0]]
  security_group_ids = module.aws-sg-opensearch.security_group_ids
}

# Security Groups
module "sg-ports-opensearch" {
  source = "git::git@github.com:Datatamer/terraform-aws-es.git//modules/es-ports?ref=5.0.0"
}

data "aws_subnet" "application_subnet" {
  id = var.application_subnet_id
}

module "aws-sg-opensearch" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.1"
  vpc_id                  = var.vpc_id
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_security_groups = concat(module.aws-sg-vm.security_group_ids, [module.ephemeral-spark-sgs.emr_managed_sg_id])
  egress_cidr_blocks      = var.egress_cidr_blocks
  ingress_ports           = module.sg-ports-opensearch.ingress_ports
  sg_name_prefix          = format("%s-%s", var.name_prefix, "-os")
  tags                    = var.tags
  ingress_protocol        = "tcp"
  egress_protocol         = "all"
}

# Only needed once per account, set `create_new_service_role` variable to true if first time running in account
resource "aws_iam_service_linked_role" "es" {
  count            = var.create_new_service_role == true ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}
