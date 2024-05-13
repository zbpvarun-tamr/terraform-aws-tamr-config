locals {
  ami_id = "ami-06a1f46caddb5669e" # Tamr BYOL AMI from the marketplace. Replace if needed.
}

data "aws_subnet" "application_subnet" {
  id = local.compute_subnet_id
}

module "tamr-vm" {
  source = "git::git@github.com:Datatamer/terraform-aws-tamr-vm.git?ref=5.1.0"

  ami                         = local.ami_id
  instance_type               = local.ec2_instance_type
  volume_size                 = local.ec2_volume_size
  key_name                    = module.emr_key_pair.key_pair_key_name
  subnet_id                   = local.application_subnet_id
  security_group_ids          = module.aws-sg-vm.security_group_ids
  availability_zone           = data.aws_subnet.application_subnet.availability_zone
  aws_role_name               = "${local.name_prefix}-tamr-ec2-role"
  aws_instance_profile_name   = "${local.name_prefix}-tamrvm-instance-profile"
  aws_emr_creator_policy_name = "${local.name_prefix}-emr-creator-policy"
  additional_policy_arns = [
    module.s3-logs.rw_policy_arn,
    module.s3-data.rw_policy_arn,
    aws_iam_policy.ssm_policy.arn
  ]
  tamr_emr_cluster_ids = [] # leave empty when using ephemeral-spark
  tamr_emr_role_arns = [
    module.emr-hbase.emr_service_role_arn,
    module.emr-hbase.emr_ec2_role_arn,
    module.ephemeral-spark-iam.emr_service_role_arn,
    module.ephemeral-spark-iam.emr_ec2_role_arn
  ]
  tags = module.tags.tags
}


module "aws-vm-sg-ports" {
  source = "git::git@github.com:Datatamer/terraform-aws-tamr-vm.git//modules/aws-security-groups?ref=5.1.0"
}

module "aws-sg-vm" {
  source              = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=1.0.1"
  vpc_id              = local.vpc_id
  ingress_cidr_blocks = local.ingress_cidr_blocks
  egress_cidr_blocks  = local.egress_cidr_blocks
  ingress_protocol    = "tcp"
  egress_protocol     = "all"
  ingress_ports       = module.aws-vm-sg-ports.ingress_ports
  sg_name_prefix      = format("%s-%s", local.name_prefix, "tamr-vm")
  tags                = module.tags.tags
}

resource "aws_iam_policy" "ssm_policy" {
  name   = "${local.name_prefix}-ssm-agent-policy"
  policy = data.aws_iam_policy_document.ssm_policy.json
  tags   = module.tags.tags
}

data "aws_iam_policy_document" "ssm_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeAssociation",
      "ssm:DescribeDocument",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:PutInventory",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}
