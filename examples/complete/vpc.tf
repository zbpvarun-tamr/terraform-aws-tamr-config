locals {
  azs = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 2)
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source                        = "git::https://github.com/Datatamer/terraform-aws-networking.git?ref=0.1.0"
  ingress_cidr_blocks           = var.ingress_cidr_blocks
  vpc_cidr_block                = var.vpc_cidr_block
  data_subnet_cidr_blocks       = var.data_subnet_cidr_blocks
  application_subnet_cidr_block = var.application_subnet_cidr_block
  compute_subnet_cidr_block     = var.compute_subnet_cidr_block
  availability_zones            = local.azs
  create_public_subnets         = false
  create_load_balancing_subnets = false
  enable_nat_gateway            = false
  tags                          = merge(var.tags, var.emr_tags)
}
