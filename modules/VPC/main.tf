
# VPC


module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "mlops-vpc"
}


# INTERNET GATEWAY


module "igw" {
  source = "./modules/igw"

  vpc_id   = module.vpc.vpc_id
  igw_name = "igw-mlops"
}


# SUBNETS


module "subnets" {
  source = "./modules/subnet"

  vpc_id = module.vpc.vpc_id

  public_subnets = {
    pub1a = {
      cidr = "10.0.101.0/24"
      az   = "eu-west-1a"
      name = "pub-subnet-1a"
    }

    pub1b = {
      cidr = "10.0.102.0/24"
      az   = "eu-west-1b"
      name = "pub-subnet-1b"
    }

    pub1c = {
      cidr = "10.0.103.0/24"
      az   = "eu-west-1c"
      name = "pub-subnet-1c"
    }
  }

  private_subnets = {
    priv1a = {
      cidr = "10.0.1.0/24"
      az   = "eu-west-1a"
      name = "priv-subnet-1a"
    }

    priv1b = {
      cidr = "10.0.2.0/24"
      az   = "eu-west-1b"
      name = "priv-subnet-1b"
    }

    priv1c = {
      cidr = "10.0.3.0/24"
      az   = "eu-west-1c"
      name = "priv-subnet-1c"
    }
  }
}


# NAT GATEWAY


module "nat" {
  source = "./modules/nat"

  public_subnet_id = module.subnets.public_subnet_ids["pub1a"]

  nat_name = "mlops-nat-gateway"
  igw_dependency = module.igw.igw_id
}


# ROUTE TABLES


module "route_tables" {
  source = "./modules/route-tables"

  vpc_id = module.vpc.vpc_id

  igw_id = module.igw.igw_id

  nat_gateway_id = module.nat.nat_gateway_id

  public_subnet_ids = values(module.subnets.public_subnet_ids)

  private_subnet_ids = values(module.subnets.private_subnet_ids)
}