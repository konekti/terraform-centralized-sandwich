
module "firewall-vpc" {

  version = ">=2.64.0"
  source  = "terraform-aws-modules/vpc/aws"

  name = "firewall-${var.ENV}"

  cidr = "172.17.0.0/16"

  azs = ["${var.AWS_REGION}b", "${var.AWS_REGION}c"]

  enable_ipv6                                    = false
  assign_ipv6_address_on_creation                = false
  map_public_ip_on_launch                        = false
  private_subnet_assign_ipv6_address_on_creation = false
  enable_nat_gateway                             = false
  create_egress_only_igw                         = false

  public_subnets  = ["172.17.0.0/24", "172.17.1.0/24"]
  private_subnets = ["172.17.100.0/24", "172.17.101.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_s3_endpoint = true

  tags = {
    Created_by  = "terraform"
    Environment = var.ENV
  }
}

module "app-vpc" {

  version = ">=2.64.0"
  source  = "terraform-aws-modules/vpc/aws"

  name = "app-vpc-${var.ENV}"

  cidr = "172.18.0.0/16"

  azs = ["${var.AWS_REGION}b", "${var.AWS_REGION}c"]

  enable_ipv6                                    = false
  assign_ipv6_address_on_creation                = false
  map_public_ip_on_launch                        = false
  private_subnet_assign_ipv6_address_on_creation = false
  enable_nat_gateway                             = false
  create_egress_only_igw                         = false

  #public_subnets  = ["172.18.0.0/24", "172.18.1.0/24"]
  private_subnets = ["172.18.100.0/24", "172.18.101.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_s3_endpoint = true

  tags = {
    Created_by  = "terraform"
    Environment = var.ENV
  }
}


