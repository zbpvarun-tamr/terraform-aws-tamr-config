# Create new EC2 key pair
resource "tls_private_key" "emr_private_key" {
  algorithm = "RSA"
}

module "emr_key_pair" {
  source     = "terraform-aws-modules/key-pair/aws"
  version    = "1.0.0"
  key_name   = "${local.name_prefix}-key"
  public_key = tls_private_key.emr_private_key.public_key_openssh
}

# Create a pem file with restricted permissions
resource "local_sensitive_file" "emr_private_key_file" {
  content         = tls_private_key.emr_private_key.private_key_pem
  filename        = "./${local.name_prefix}-key.pem"
  file_permission = "0600"
}
