# Generate random password for db
resource "random_password" "rds-password" {
  length  = 16
  special = false
}

module "rds-postgres" {
  source = "git::git@github.com:Datatamer/terraform-aws-rds-postgres.git?ref=4.1.0"

  identifier_prefix = "${local.name_prefix}-"
  username          = "tamr"
  password          = random_password.rds-password.result

  subnet_group_name    = "${local.name_prefix}-subnet-group"
  postgres_name        = "tamr0"
  parameter_group_name = "${local.name_prefix}-rds-postgres-pg"

  # Network requirement: DB subnet group needs a subnet in at least two AZs
  rds_subnet_ids = local.data_subnet_ids
  multi_az       = false

  security_group_ids = module.rds-postgres-sg.security_group_ids
  tags               = module.tags.tags

  allocated_storage     = 20
  max_allocated_storage = 1000
  instance_class        = "db.r6g.large"
}

module "sg-ports-rds" {
  source = "git::git@github.com:Datatamer/terraform-aws-rds-postgres.git//modules/rds-postgres-ports?ref=4.1.0"
}

module "rds-postgres-sg" {
  source                  = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.1"
  vpc_id                  = local.vpc_id
  ingress_cidr_blocks     = local.ingress_cidr_blocks
  ingress_security_groups = module.aws-sg-vm.security_group_ids
  egress_cidr_blocks      = local.egress_cidr_blocks
  ingress_ports           = module.sg-ports-rds.ingress_ports
  sg_name_prefix          = local.name_prefix
  egress_protocol         = "all"
  ingress_protocol        = "tcp"
  tags                    = module.tags.tags
}
