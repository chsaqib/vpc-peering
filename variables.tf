variable "vpc_name" {}
variable "region" {
  description = "AWS Region for vpc"
  default     = "eu-west-1"
}
variable "cidrs" {
  type = map
  default = {
    dev   = "10.20.0.0/16"
    test  = "10.10.0.0/16"
    root  = "10.50.0.0/16"
  }
}
variable "vpn_name" {
  description = "OpenVPN name"
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
variable "private_subnets" {
  type = map
  default = {
    dev   = ["10.20.1.0/24", "10.20.3.0/24", "10.20.5.0/24"]
    test  = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24"]
    root  = ["10.50.1.0/24", "10.50.3.0/24", "10.50.5.0/24"]
  }
}
variable "public_subnets" {
  type = map
  default = {
    dev   = ["10.20.0.0/24", "10.20.2.0/24", "10.20.4.0/24"]
    test  = ["10.10.0.0/24", "10.10.2.0/24", "10.10.4.0/24"]
    root  = ["10.50.0.0/24", "10.50.2.0/24", "10.50.4.0/24"]
  }
}
variable "database_subnets" {
  type = map
  default = {
    dev   = ["10.20.50.0/24", "10.20.51.0/24", "10.20.52.0/24"]
    test  = ["10.10.50.0/24", "10.10.51.0/24", "10.10.52.0/24"]
    root  = ["10.50.50.0/24", "10.50.51.0/24", "10.50.52.0/24"]
  }
}
variable "vpc_ids" {
  type = map
  default = {
    dev   = "REPLACE_WITH_YOUR_VPCID"
    test  = "REPLACE_WITH_YOUR_VPCID"
  }
}
variable "acceptor_intra_subnet_names" {
  type = map
  default = {
    dev   = "REPLACE_WITH_YOUR_DEV_INTRA_SUBNET_NAME"
    test  = "REPLACE_WITH_YOUR_TEST_INTRA_SUBNET_NAME"
 }
}