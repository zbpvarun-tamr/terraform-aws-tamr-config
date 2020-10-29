module "tamr-vm" {
  source = "git::git@github.com:Datatamer/terraform-emr-tamr-vm?ref=0.4.0"

  ami                 = var.ami_id
  instance_type       = "m4.2xlarge"
  key_name            = module.emr_key_pair.this_key_pair_key_name
  subnet_id           = local.subnet_ec2_a
  vpc_id              = local.vpc_id
  sg_name             = "${var.name_prefix}-tamrvm-sg"
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_cidr_blocks  = ["0.0.0.0/0"] # TODO: scope down

  aws_role_name               = "${var.name_prefix}-tamr-ec2-role"
  aws_instance_profile_name   = "${var.name_prefix}-tamrvm-instance-profile"
  aws_emr_creator_policy_name = "${var.name_prefix}-emr-creator-policy"
  s3_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn
  ]
}
