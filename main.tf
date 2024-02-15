provider "aws" {
  region = var.region
}
provider "aws" {
  alias                   = "root"
  region                  = var.region
  shared_credentials_file = "$Home/.aws/credentials" # -->replace with your path to .aws/credentials
  version                 = "~> 2.13"
  profile                 = "root"
}
provider "aws" {
  alias                   = "dev"
  region                  = var.region
  shared_credentials_file = "$Home/.aws/credentials"
  version                 = "~> 2.13"
  assume_role {
    role_arn = "arn:aws:iam::############:role/Admin"
  }
}
provider "aws" {
  alias                   = "test"
  region                  = var.region
  shared_credentials_file = "$Home/.aws/credentials"
  version                 = "~> 2.13"
  assume_role {
    role_arn = "arn:aws:iam::::############::role/Admin"
  }
}
data "aws_caller_identity" "dev" {
  provider = aws.dev
}
data "aws_caller_identity" "test" {
 provider = aws.test
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.vpc_name
  cidr                 = var.cidrs[terraform.workspace]
  azs                  = var.availability_zones
  private_subnets      = var.private_subnets[terraform.workspace]
  public_subnets       = var.public_subnets[terraform.workspace]
  intra_subnets        = var.database_subnets[terraform.workspace]
  enable_dns_support   = true
  enable_dns_hostnames = true
  database_subnet_group_tags = {
    Name        = "DB subnet group"
    Environment = terraform.workspace
  }
  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true
  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

module root_vpc_to_dev {
  source                     = "./modules/vpc_peering"
  peer_region                = var.region
  vpc_id                     = module.vpc.vpc_id
  peer_vpc_id                = var.vpc_ids["dev"]
  peer_owner_id              =    data.aws_caller_identity.dev.account_id
  acceptor_cidr_block        = var.cidrs["dev"]
  requestor_cidr_block       = var.cidrs["root"]
  route_table_id             = module.vpc.public_route_table_ids[0]
  acceptor_intra_subnet_name = var.acceptor_intra_subnet_names["dev"]
  providers = {
    aws.src = aws.root
    aws.dst = aws.dev
  }
}
module root_vpc_to_test {
  source                     = "./modules/vpc_peering"
  peer_region                = var.region
  vpc_id                     = module.vpc.vpc_id
  peer_vpc_id                = var.vpc_ids["test"]
  peer_owner_id              =    data.aws_caller_identity.test.account_id
  acceptor_cidr_block        = var.cidrs["test"]
  requestor_cidr_block       = var.cidrs["root"]
  route_table_id             = module.vpc.public_route_table_ids[0]
  acceptor_intra_subnet_name =   var.acceptor_intra_subnet_names["test"]
  providers = {
    aws.src = aws.root
    aws.dst = aws.test
  }
}