variable "name_prefix" {
  type        = string
  description = "A prefix to add to the names of all created resources."
  default     = "tamr-config-test"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which ingress to ElasticSearch domain, Tamr VM, Tamr Postgres instance are allowed (i.e. VPN CIDR)"
  default     = []
}

variable "ami_id" {
  type        = string
  description = "AMI to use for Tamr EC2 instance"
}

variable "license_key" {
  type        = string
  description = "Tamr license key"
}
